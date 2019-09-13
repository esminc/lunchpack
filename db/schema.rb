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

ActiveRecord::Schema.define(version: 2019_09_13_012432) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_assignments_on_member_id"
    t.index ["project_id"], name: "index_assignments_on_project_id"
  end

  create_table "lunches", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "quarter_id"
    t.bigint "user_id"
    t.index ["quarter_id"], name: "index_lunches_on_quarter_id"
    t.index ["user_id"], name: "index_lunches_on_user_id"
  end

  create_table "lunches_members", id: false, force: :cascade do |t|
    t.bigint "lunch_id", null: false
    t.bigint "member_id", null: false
    t.index ["lunch_id"], name: "index_lunches_members_on_lunch_id"
    t.index ["member_id"], name: "index_lunches_members_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "hundle_name"
    t.string "real_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.boolean "retired", default: false, null: false
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["retired"], name: "index_members_on_retired"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quarters", force: :cascade do |t|
    t.integer "period", null: false
    t.integer "ordinal", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["period", "ordinal"], name: "index_quarters_on_period_and_ordinal", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.string "meta"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "assignments", "members"
  add_foreign_key "assignments", "projects"
  add_foreign_key "lunches", "quarters"
  add_foreign_key "lunches", "users"
end
