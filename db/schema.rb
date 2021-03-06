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

ActiveRecord::Schema.define(version: 20171009075957) do

  create_table "feedbacks", force: :cascade do |t|
    t.string   "comments"
    t.integer  "overall"
    t.integer  "cleanliness"
    t.integer  "odour"
    t.integer  "safety"
    t.integer  "wait_time"
    t.datetime "check_in"
    t.integer  "user_id",     limit: 20
    t.integer  "toilet_id",   limit: 20
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "opening_hours", force: :cascade do |t|
    t.string   "day"
    t.integer  "open_time"
    t.integer  "close_time"
    t.string   "toilet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string   "caption"
    t.string   "photo_url"
    t.integer  "user_id"
    t.integer  "toilet_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "storage_url"
  end

  create_table "toilets", force: :cascade do |t|
    t.string   "title"
    t.string   "location"
    t.string   "description"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "parentsRoom",    default: false
    t.boolean  "gender_neutral", default: false
    t.boolean  "disabled_opt",   default: false
    t.boolean  "female",         default: false
    t.boolean  "male",           default: false
    t.float    "lon"
    t.float    "lat"
    t.string   "image"
    t.boolean  "public_data",    default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "admin",      default: false
    t.string   "password"
  end

end
