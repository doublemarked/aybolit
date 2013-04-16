namespace :rebuild do
  desc "Rebuild all aggregate data"
  task :all => :environment do
    Rake::Task["rebuild:locations"].execute
    Rake::Task["rebuild:stats"].execute
  end

  desc "Rebuilt Location data from Hospital addresses"
  task :locations => :environment do
    puts "Rebuilding location data..."
    Location.delete_all
    Hospital.all.each do |h|
      unless Location.where(:name => h.display_address).exists?
        # This will ensure the new location is geocoded
        Location.new(:name => h.display_location).save
        putc "."
      end
    end
    puts "\nDone."
  end

  desc "Rebuild Hospital and Doctor aggregate stats"
  task :stats => :environment do
    puts "Rebuilding aggregated hospital stats..."
    Hospital.all.each do |h|
      latest = h.reports.select("reports.created_at").order("reports.created_at DESC").first
      h.latest_at = latest[:created_at] if latest
      h.num_reports = h.reports.count
      h.num_delivered = h.reports.delivered.count
      h.save(:validate => false)
      putc "."
    end
    
    puts "\nRebuilding aggregated doctor stats..."
    Doctor.all.each do |d|
      latest = d.reports.select("reports.created_at").order("reports.created_at DESC").first
      d.latest_at = latest[:created_at] if latest
      d.num_reports = d.reports.count
      d.num_delivered = d.reports.delivered.count
      d.save(:validate => false)
      putc "."
    end

    puts "\nDone."
  end

end
