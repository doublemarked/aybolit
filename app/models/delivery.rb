class Delivery < ActiveRecord::Base
  has_many :reports

  attr_accessible :manager, :delivered, :recipients
end
