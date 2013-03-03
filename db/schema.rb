# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130209193303) do

  create_table "deliveries", :force => true do |t|
    t.string   "manager"
    t.boolean  "delivered_doctor"
    t.boolean  "delivered_hospital"
    t.date     "delivered"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "doctors", :force => true do |t|
    t.integer  "hospital_id"
    t.string   "name"
    t.string   "specialization"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.datetime "latest_at"
    t.integer  "num_reports",    :default => 0
    t.integer  "num_delivered",  :default => 0
  end

  create_table "endorsements", :force => true do |t|
    t.integer  "report_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "endorsements", ["report_id"], :name => "index_endorsements_on_report_id"
  add_index "endorsements", ["user_id"], :name => "index_endorsements_on_user_id"

  create_table "hospitals", :force => true do |t|
    t.string   "name"
    t.string   "director"
    t.string   "address"
    t.string   "address2"
    t.string   "township"
    t.string   "district"
    t.string   "oblast"
    t.string   "postal"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "rating"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "country"
    t.integer  "num_reports",   :default => 0
    t.integer  "num_delivered", :default => 0
    t.datetime "latest_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "doctor_id"
    t.integer  "delivery_id"
    t.text     "doctor_experience"
    t.text     "hospital_experience"
    t.date     "occurred"
    t.integer  "views"
    t.boolean  "visible"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "endorsements_count",  :default => 0
  end

  add_index "reports", ["doctor_id"], :name => "index_reports_on_doctor_id"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.text     "description"
    t.string   "location"
    t.string   "image"
    t.text     "urls"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
