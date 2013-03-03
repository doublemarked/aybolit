class AddLatestReportDateToDoctor < ActiveRecord::Migration
  def change
    add_column :doctors, :latest_at, :datetime
  end
end
