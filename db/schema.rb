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

ActiveRecord::Schema.define(version: 20190306065634) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_otps", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "otp_value"
    t.boolean  "is_validated"
    t.datetime "expiry_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_user_otps_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "first_name",             default: ""
    t.string   "last_name",              default: ""
    t.string   "contact_number",         default: ""
    t.integer  "role",                   default: 0
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "status",                 default: 1
    t.datetime "deleted_at"
    t.string   "mobile_number"
    t.string   "otp_secret_key"
    t.string   "avatar"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["mobile_number"], name: "index_users_on_mobile_number", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["status"], name: "index_users_on_status", using: :btree
  end

  add_foreign_key "user_otps", "users"
end
