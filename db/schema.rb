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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150221194503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "photos", force: true do |t|
    t.string   "url"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["venue_id"], name: "index_photos_on_venue_id", using: :btree

  create_table "reactions", force: true do |t|
    t.string   "user_id"
    t.string   "reaction"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reactions", ["created_at"], name: "index_reactions_on_created_at", using: :btree
  add_index "reactions", ["photo_id"], name: "index_reactions_on_photo_id", using: :btree
  add_index "reactions", ["user_id"], name: "index_reactions_on_user_id", using: :btree

  create_table "venues", force: true do |t|
    t.string   "foursquare_venue_id"
    t.string   "name"
    t.string   "phone_number"
    t.text     "address"
    t.text     "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "venue_pic"
    t.integer  "lat"
    t.integer  "lon"
  end

end
