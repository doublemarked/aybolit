class RenameGeoFields < ActiveRecord::Migration
  def change
    add_column :hospitals, :country, :string
    rename_column :hospitals, :geo_lat, :latitude
    rename_column :hospitals, :geo_lng, :longitude
  end
end
