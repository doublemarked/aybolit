class Location < ActiveRecord::Base
  attr_accessible :name, :latitude, :longitude

  geocoded_by :name   
  after_validation :geocode
end
