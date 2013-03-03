class Endorsement < ActiveRecord::Base
  belongs_to :report, :counter_cache => true
  belongs_to :user

  attr_accessible :report, :user

  validates_presence_of :report, :user
end
