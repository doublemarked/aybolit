class CreateEndorsements < ActiveRecord::Migration
  def up
    remove_column :reports, :endorsements 
    add_column :reports, :endorsements_count, :integer, :default => 0

    create_table :endorsements do |t|
      t.references :report
      t.references :user

      t.timestamps
    end

    add_index :endorsements, :report_id
    add_index :endorsements, :user_id
  end

  def down
    drop_table :endorsements
    add_column :reports, :endorsements, :integer
  end
end
