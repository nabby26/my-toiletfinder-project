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

ActiveRecord::Schema.define(version: 20171003114152) do

  create_table "feedbacks", force: :cascade do |t|
    t.string   "comment"
    t.integer  "overall"
    t.integer  "cleanliness"
    t.integer  "odour"
    t.integer  "safety"
    t.integer  "wait_time"
    t.datetime "check_in"
    t.integer  "users_id"
    t.integer  "toilets_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["toilets_id"], name: "index_feedbacks_on_toilets_id"
    t.index ["users_id"], name: "index_feedbacks_on_users_id"
  end

  create_table "toilets", force: :cascade do |t|
    t.string   "title"
    t.string   "location"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
