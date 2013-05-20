class AddPhoneToHospital < ActiveRecord::Migration
  def change
    add_column :hospitals, :phone, :string
  end
end
