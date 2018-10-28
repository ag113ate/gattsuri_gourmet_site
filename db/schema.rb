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

ActiveRecord::Schema.define(version: 20181018095634) do

  create_table "bookmark_stores", force: :cascade do |t|
    t.string   "user_id"
    t.string   "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: :cascade do |t|
    t.integer  "pref_code"
    t.string   "pref_name"
    t.string   "city_name"
    t.binary   "is_designated_cities"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "food_images", force: :cascade do |t|
    t.string   "store_id"
    t.integer  "vote_id"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "input_reviews", id: false, force: :cascade do |t|
    t.integer  "vote_id"
    t.string   "user_id"
    t.string   "store_id"
    t.string   "menu_name"
    t.text     "comment"
    t.float    "total_score"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", id: false, force: :cascade do |t|
    t.integer  "vote_id"
    t.string   "user_id"
    t.string   "store_id"
    t.string   "menu_name"
    t.text     "comment"
    t.float    "total_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", id: false, force: :cascade do |t|
    t.string   "store_id"
    t.string   "name"
    t.float    "score"
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

  create_table "sub_cities", force: :cascade do |t|
    t.integer  "city_id"
    t.string   "sub_city_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string   "user_id"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
