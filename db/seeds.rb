# encoding: utf-8
#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

User.create({ :id => 0, :provider => "system", :uid => "system", :name => "System User"  })

# Load environment-specific seeds
load("db/seeds/#{Rails.env}.rb") if File.exists?("db/seeds/#{Rails.env}.rb")

