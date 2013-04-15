
class FeedbackController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    begin
      @feedback = Feedback.new(params[:feedback])
      @feedback.request = request
      if @feedback.deliver
        session[:message_title] = I18n.t('message.title.generic')
        session[:message] = I18n.t('feedback.submission-message') 
        redirect_to page_path(:message)
      else
        render :new
      end
    rescue ScriptError
      flash[:error] = I18n.t('feedback.spam-message') 
    end
  end
end
