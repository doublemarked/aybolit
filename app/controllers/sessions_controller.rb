class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]

    @user = User.find_or_make_with_omniauth(auth)
    @user.save
    set_current_user(@user)

    if session[:pending_report].present?
      flash.keep

      report = Report.unscoped.find(session[:pending_report])
      report.user = @user
      report.visible = true
      report.save

      session.delete(:pending_report)

      redirect_to report
    else
      redirect_to root_url, :notice => "Login successful!"
    end
  end

  # Having some trouble cleanly linking the VK client Auth API with OmniAuth. This is 
  # because their JS API doesn't provide oauth tokens. So, we're verifying userid manually
  # and then injecting users using client data.
  # FIXME: The user info here (name, etc. but not VK id) is actually unconfirmed, and can suffer from
  # client fraud.
  def create_vkclient
    
    #logger.debug "COOKIE: #{ request.cookies["vk_app_#{ENV['VKONTAKTE_KEY']}"] }"

    if !verify_vk_signature( request.cookies["vk_app_#{ENV['VKONTAKTE_KEY']}"] )
      render :json => { :status => 'failure', :error => "Auth Signature failed check." }
      return
    end

    auth = {
      'uid' => params[:mid],
      'provider' => 'vkontakte',
      'info' => {
        'nickname' => params[:user][:nickname],
        'name' => params[:user][:first_name]+" "+params[:user][:last_name],
        'first_name' => params[:user][:first_name],
        'last_name' => params[:user][:last_name],
        'image' => params[:user][:photo],
        'urls' => { 'Page' => params[:user][:href] }
      }
    }

    @user = User.find_or_make_with_omniauth(auth)
    logger.debug "CURRENT USER: #{@user.id}"
    @user.save
    set_current_user(@user)
    
    respond_to do |format|
      format.json { render :json => { :status => 'success', :user_id => @user.id } }
    end
  end

  # We don't always have the full user content, but we can always attempt to link
  # using the cookie.
  def link_vkclient
    vk_cookie = request.cookies["vk_app_#{ENV['VKONTAKTE_KEY']}"]
    if !verify_vk_signature( vk_cookie )
      render :json => { :status => 'failure', :error => I18n.t('messages.vk_sig_failed') }
      return
    end

    args = Rack::Utils.parse_query(vk_cookie)
    @user = User.find_by_provider_and_uid( 'vkontakte', args['mid'] )

    if (@user) 
      set_current_user(@user)
    end

    respond_to do |format|
      format.json { render :json => { :status => 'success', :user_id => @user.id } }
    end
  end

  def failure
      redirect_to page_url(:identify)
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => I18n.('messages.logged_out')
  end


  private
  
  def verify_vk_signature(vk_cookie)
    return false unless vk_cookie

    args = Rack::Utils.parse_query(vk_cookie)

    return false unless args['expire'].to_i > Time.now.to_i

    sign = args.slice('expire','mid','secret','sid').map { |k,v| "#{k}=#{v}" }.sort.join() + ENV['VKONTAKTE_SECRET']
    digest = Digest::MD5.hexdigest(sign);

    return digest == args['sig']
  end

end
