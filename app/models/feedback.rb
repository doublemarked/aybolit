class Feedback < MailForm::Base
  attribute :name, :validate => false
  attribute :email, :validate => false
  
  # These are used only for the prereq modal's form
  attribute :bribe_given
  attribute :initiated_by
  attribute :bribe_type 
  attribute :thinks_it_works
   
  attribute :message

  # These request properties will be added to the message
  append :remote_ip

  # This field, if set, will cause the message to be flagged as spam.
  # It is bait for spambots. It uses an obscure name on purpose.
  attribute :reference, :captcha => true

  def headers
    {
      :subject => I18n.t("project.email-subject", :locale => "en"),
      :to => I18n.t("project.email-recipient", :locale => "en"),
      :from => %("#{name}" <#{email}>)
    }
  end

end

