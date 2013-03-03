class User < ActiveRecord::Base
  has_many :reports
  has_many :endorsements

  attr_accessible :description, :email, :first_name, :image, :last_name, :location, :name, :nickname, :phone, :provider, :uid, :urls

  def self.find_with_omniauth(auth)
    find_by_provider_and_uid(auth['provider'].to_s, auth['uid'].to_s)
  end

  def self.make_with_omniauth(auth)
    fields = { :uid => auth['uid'], :provider => auth['provider'] }

    # Explicit field selection, because Some OmniAuth strategies don't stick 
    # to the Auth Hash spec and return non-standard fields in the info section. 
    fields.merge! auth['info'].slice(*%w/nickname name first_name last_name email 
                                         phone description location image urls/)

    # We're serializing urls and would prefer them to be native Hashes, not Hashies.
    fields['urls'] = fields['urls']? fields['urls'].to_hash : {}

    new(fields)
  end

  def self.find_or_make_with_omniauth(auth)
    find_with_omniauth(auth) or make_with_omniauth(auth)
  end

  def endorse(report)
    unless Endorsement.find_by_user_id_and_report_id(self.id, report.id)
      Endorsement.create(:user => self, :report => report)
    end 
  end

  def display_name
    value = "#{first_name[0]}. " if first_name
    value += last_name if last_name
    return value
  end

end
