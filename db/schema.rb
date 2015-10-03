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

ActiveRecord::Schema.define(version: 20150408150844) do

  create_table "aliases", force: true do |t|
    t.string   "gerrit_username"
    t.string   "slack_username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", force: true do |t|
    t.string   "name"
    t.string   "projects"
    t.string   "owners"
    t.boolean  "emoji_enabled",              default: true
    t.text     "qa_product_approved_emojis"
    t.text     "qa_approved_emojis"
    t.text     "product_approved_emojis"
    t.text     "merged_emojis"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "regexes"
  end

  create_table "users", force: true do |t|
    t.boolean  "admin",              default: false
    t.boolean  "superadmin",         default: false
    t.string   "email",              default: "",    null: false
    t.string   "encrypted_password", default: "",    null: false
    t.string   "username",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
