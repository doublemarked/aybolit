class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :system_user, :logged_in?, :base_domain, :base_url, :localized_domain, :localized_url, :locale_redirect_url

  before_filter :set_locale

  DOMAIN_LOCALE_MAPPING = { 'ua' => :uk }
  LOCALE_DOMAIN_MAPPING = DOMAIN_LOCALE_MAPPING.invert

  def set_locale
    subdomains = request.subdomains
    parsed_locale = subdomains.first != 'www' ? subdomains.first : subdomains.second

    parsed_locale = DOMAIN_LOCALE_MAPPING[parsed_locale] if DOMAIN_LOCALE_MAPPING.include?(parsed_locale)
    parsed_locale = parsed_locale.to_sym unless parsed_locale.nil?

    if I18n.available_locales.include?(parsed_locale)
      logger.info "Assigning Locale: #{parsed_locale}"
      I18n.locale = parsed_locale
    else 
      logger.info "Bad locale '#{parsed_locale}'. Redirecting to default locale '#{I18n.default_locale}'"
      redirect_to locale_redirect_url(I18n.default_locale)
      return nil
    end
  end

  def current_user
    @current_user ||= (User.find_by_id(session[:user_id]) if session[:user_id])
  end

  def set_current_user(user)
    @current_user = user
    session[:user_id] = user.nil? ? nil : user.id
  end

  def system_user 
    User.find_by_provider("system")
  end

  def logged_in?
    !!current_user
  end

  def base_domain
    ENV['SITE_BASE_DOMAIN']
  end

  def base_url(qs = "")
    url = request.protocol + base_domain
    url += ":"+request.port.to_s if request.port != 80

    return url + qs
  end

  def localized_domain(locale = I18n.locale)
    subdomain = LOCALE_DOMAIN_MAPPING.include?(locale) ? LOCALE_DOMAIN_MAPPING[locale] : locale
    subdomain.to_s + "." + base_domain
  end

  def localized_url(qs = "", locale = I18n.locale) 
    url = request.protocol + localized_domain(locale)
    url += ":"+request.port.to_s if request.port != 80

    return url + qs
  end

  def locale_redirect_url(locale)
    localized_url(request.env['REQUEST_URI'], locale)
  end

end
