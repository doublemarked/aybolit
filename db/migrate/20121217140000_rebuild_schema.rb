class RebuildSchema < ActiveRecord::Migration

  def change
    create_table :hospitals do |t|
      t.string  :name
      t.string  :director
      t.string  :address
      t.string  :address2
      t.string  :township
      t.string  :district
      t.string  :oblast
      t.string  :postal
      t.float   :geo_lat
      t.float   :geo_lng
      t.integer :rating

      t.timestamps
    end
    
    create_table :doctors do |t|
      t.references :hospital
      t.string :name
      t.string :specialization

      t.timestamps
    end

    create_table :reports do |t|
      t.references :user
      t.references :doctor
      t.references :delivery
      t.text       :doctor_experience
      t.text       :hospital_experience
      t.date       :occurred
      t.integer    :views
      t.integer    :endorsements
      t.boolean    :visible 

      t.timestamps
    end

    add_index :reports, [:doctor_id], :name => "index_reports_on_doctor_id"

    create_table :users do |t|
      t.string   :provider
      t.string   :uid
      t.string   :nickname
      t.string   :name
      t.string   :first_name
      t.string   :last_name
      t.string   :email
      t.string   :phone
      t.text     :description
      t.string   :location
      t.string   :image
      t.text     :urls

      t.timestamps
    end

    create_table :deliveries do |t|
      t.string   :manager
      t.boolean  :delivered_doctor
      t.boolean  :delivered_hospital
      t.date     :delivered

      t.timestamps
    end

  end
end
