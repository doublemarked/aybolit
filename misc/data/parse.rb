#!/usr/bin/env ruby

require 'csv'

class Hospital 
  attr_accessor :name, :address, :city, :postal, :street, :director, :phone
end


#CSV.foreach(ARGV.first, encoding: "UTF-8").each do |r|
#  puts "Here: #{ r.inspect }"
#end


#file_contents = CSV.read("test.csv", encoding: "UTF-8")
#puts "FC: #{ file_contents.inspect }"

hospitals_raw = CSV.read(ARGV.first, encoding: "UTF-8")

hospitals = []
i = 0
hospitals_raw.each do |r|
  puts "L: #{i}"
  h = Hospital.new

  h.name = (r[0] || "").strip
  h.director = (r[1] || "").strip
  h.phone = (r[2] || "").strip
  addr = (r[3] || "").strip

  puts addr
  i = i +1 
end


puts "DONE"


