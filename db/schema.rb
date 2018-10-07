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

ActiveRecord::Schema.define(version: 20181006093234) do

  create_table "bookmark_stores", force: true do |t|
    t.string   "user_id"
    t.string   "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "food_images", force: true do |t|
    t.string   "store_id"
    t.integer  "vote_id"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "input_reviews", primary_key: "vote_id", force: true do |t|
    t.string   "menu_name"
    t.text     "comment"
    t.float    "total_score"
    t.string   "image"
    t.string   "change_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", primary_key: "vote_id", force: true do |t|
    t.string   "user_id"
    t.string   "store_id"
    t.string   "menu_name"
    t.text     "comment"
    t.float    "total_score"
    t.datetime "update_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", primary_key: "store_id", force: true do |t|
    t.string   "name"
    t.float    "review"
    t.string   "opentime"
    t.string   "holiday"
    t.string   "tel"
    t.string   "address"
    t.string   "line"
    t.string   "station"
    t.string   "station_exit"
    t.integer  "walk"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "category_name_l"
    t.string   "shop_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stores", ["store_id"], name: "sqlite_autoindex_stores_1", unique: true

  create_table "users", primary_key: "user_id", force: true do |t|
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["user_id"], name: "sqlite_autoindex_users_1", unique: true

end
