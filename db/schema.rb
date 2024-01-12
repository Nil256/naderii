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

ActiveRecord::Schema.define(version: 2024_01_12_032441) do

  create_table "cries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "timeline_id", null: false
    t.text "body", null: false
    t.boolean "is_personal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "send_user_id"
    t.integer "receive_user_id"
    t.string "action", default: "", null: false
    t.integer "actioned_target_id"
    t.boolean "is_checked", default: false, null: false
    t.text "additional_messages", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pets", force: :cascade do |t|
    t.integer "user_id"
    t.integer "cry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timeline_follows", force: :cascade do |t|
    t.integer "user_id"
    t.integer "timeline_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timelines", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "timelinename", null: false
    t.string "display_name", null: false
    t.text "introduction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_dummy", default: false, null: false
    t.boolean "is_transferring", default: false, null: false
    t.index ["timelinename"], name: "index_timelines_on_timelinename", unique: true
  end

  create_table "user_follows", force: :cascade do |t|
    t.integer "user_id"
    t.integer "followed_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.string "display_name", default: "ユーザー", null: false
    t.string "profile_image_id"
    t.text "introduction"
    t.boolean "is_administrator", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
