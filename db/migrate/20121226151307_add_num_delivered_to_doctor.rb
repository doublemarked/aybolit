class AddNumDeliveredToDoctor < ActiveRecord::Migration
  def change
    add_column :doctors, :num_delivered, :integer, :default => 0
  end
end
