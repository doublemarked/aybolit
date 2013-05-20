# encoding: utf-8

namespace :import do
  desc "Import hospital data"
  task :hospitals, [:filename] => :environment do |t, args|
    require 'csv'

    puts "Importing from #{ args[:filename] }"
    hospitals_raw = CSV.read(args[:filename], encoding: "UTF-8")
    hospitals_raw.each do |r|
      #puts "R: #{r}"
      r = r.map { |i| (i || "").strip }

      h = Hospital.new(
        :name      => r[0],
        :director  => r[1],
        :address   => r[2],
        :address2  => r[3],
        :phone     => r[4],
        :township  => r[6],
        :district  => r[7],
        :oblast    => r[8],
        :postal    => r[9],
        :country   => r[10]
      )

      unless h.save 
        puts "Error saving: #{ h.errors.messages }"
        puts "Row: #{r}"
      end

    end
  end
end
