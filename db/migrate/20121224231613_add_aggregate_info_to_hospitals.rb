class AddAggregateInfoToHospitals < ActiveRecord::Migration
  def change
    add_column :doctors, :num_reports, :integer, :default => 0
    add_column :hospitals, :num_reports, :integer, :default => 0
    add_column :hospitals, :num_delivered, :integer, :default => 0
    add_column :hospitals, :latest_at, :datetime
  end
end
