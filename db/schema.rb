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

ActiveRecord::Schema.define(version: 20170502201750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "btree_gin"
  enable_extension "unaccent"
  enable_extension "cube"
  enable_extension "earthdistance"

  create_table "cities", force: :cascade do |t|
    t.integer  "state_id"
    t.integer  "country_id",                                           null: false
    t.integer  "timezone_id",                                          null: false
    t.string   "name",                                                 null: false
    t.string   "key",                                                  null: false
    t.string   "full_name",                                            null: false
    t.boolean  "capital",                              default: false
    t.integer  "population"
    t.decimal  "latitude",    precision: 10, scale: 6,                 null: false
    t.decimal  "longitude",   precision: 10, scale: 6,                 null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.index "ll_to_earth((latitude)::double precision, (longitude)::double precision)", name: "cities_earthdistance_ix", using: :gist
    t.index ["country_id"], name: "index_cities_on_country_id", using: :btree
    t.index ["full_name"], name: "index_cities_on_full_name", using: :gin
    t.index ["key"], name: "index_cities_on_key", unique: true, using: :btree
    t.index ["state_id"], name: "index_cities_on_state_id", using: :btree
    t.index ["timezone_id"], name: "index_cities_on_timezone_id", using: :btree
  end

  create_table "continents", force: :cascade do |t|
    t.string   "abbreviation", null: false
    t.string   "name",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "countries", force: :cascade do |t|
    t.integer  "continent_id", null: false
    t.string   "abbreviation", null: false
    t.string   "name",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["abbreviation"], name: "index_countries_on_abbreviation", unique: true, using: :btree
    t.index ["continent_id"], name: "index_countries_on_continent_id", using: :btree
    t.index ["name"], name: "index_countries_on_name", using: :gin
  end

  create_table "invitations", force: :cascade do |t|
    t.integer  "inviter_id", null: false
    t.string   "invitee",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inviter_id"], name: "index_invitations_on_inviter_id", using: :btree
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.boolean  "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.string   "homepage"
    t.string   "repository"
    t.string   "description"
    t.string   "thumbnail"
    t.string   "language"
    t.integer  "position"
    t.boolean  "hide"
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "syncing"
    t.boolean  "fork"
    t.integer  "stars"
    t.integer  "forks"
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "setup_covers", force: :cascade do |t|
    t.string   "url",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "snapshots", force: :cascade do |t|
    t.date     "date"
    t.integer  "count_users",                               default: 0,   null: false
    t.integer  "count_projects",                            default: 0,   null: false
    t.integer  "count_domains",                             default: 0,   null: false
    t.float    "total_user_completeness",                   default: 0.0, null: false
    t.integer  "count_user_weak_completeness",              default: 0,   null: false
    t.integer  "count_user_medium_completeness",            default: 0,   null: false
    t.integer  "count_user_strong_completeness",            default: 0,   null: false
    t.integer  "count_user_very_strong_completeness",       default: 0,   null: false
    t.integer  "count_invitations",                         default: 0,   null: false
    t.integer  "count_invitation_rewards",                  default: 0,   null: false
    t.integer  "count_zero_invitations",                    default: 0,   null: false
    t.integer  "count_one_invitations",                     default: 0,   null: false
    t.integer  "count_two_invitations",                     default: 0,   null: false
    t.integer  "count_three_invitations",                   default: 0,   null: false
    t.integer  "count_four_invitations",                    default: 0,   null: false
    t.integer  "count_five_invitations",                    default: 0,   null: false
    t.integer  "count_six_more_invitations",                default: 0,   null: false
    t.integer  "daily_count_users",                         default: 0,   null: false
    t.integer  "daily_count_projects",                      default: 0,   null: false
    t.integer  "daily_count_domains",                       default: 0,   null: false
    t.float    "daily_total_user_completeness",             default: 0.0, null: false
    t.integer  "daily_count_user_weak_completeness",        default: 0,   null: false
    t.integer  "daily_count_user_medium_completeness",      default: 0,   null: false
    t.integer  "daily_count_user_strong_completeness",      default: 0,   null: false
    t.integer  "daily_count_user_very_strong_completeness", default: 0,   null: false
    t.integer  "daily_count_invitations",                   default: 0,   null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.index ["date"], name: "index_snapshots_on_date", unique: true, using: :btree
  end

  create_table "states", force: :cascade do |t|
    t.integer  "country_id",   null: false
    t.string   "abbreviation", null: false
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["abbreviation", "country_id"], name: "index_states_on_abbreviation_and_country_id", unique: true, using: :btree
    t.index ["country_id"], name: "index_states_on_country_id", using: :btree
  end

  create_table "timezones", force: :cascade do |t|
    t.integer  "country_id", null: false
    t.string   "slug",       null: false
    t.string   "name",       null: false
    t.integer  "offset_1",   null: false
    t.integer  "offset_2",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_timezones_on_country_id", using: :btree
    t.index ["slug"], name: "index_timezones_on_slug", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                           default: "", null: false
    t.string   "encrypted_password",                              default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "github_uid"
    t.string   "github_token"
    t.string   "name"
    t.string   "username"
    t.string   "avatar"
    t.string   "cover"
    t.string   "bio"
    t.string   "role"
    t.string   "location"
    t.string   "company"
    t.string   "company_website"
    t.string   "website"
    t.boolean  "hireable"
    t.json     "skills"
    t.string   "linkedin"
    t.string   "angellist"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "google_plus"
    t.string   "stack_overflow"
    t.string   "codepen"
    t.string   "jsfiddle"
    t.string   "medium"
    t.string   "blog"
    t.string   "behance"
    t.string   "dribbble"
    t.string   "pinterest"
    t.string   "display_email"
    t.string   "domain"
    t.boolean  "admin"
    t.integer  "plan_id"
    t.decimal  "latitude",               precision: 10, scale: 6
    t.decimal  "longitude",              precision: 10, scale: 6
    t.integer  "city_id"
    t.integer  "country_id"
    t.float    "completeness"
    t.json     "completeness_details"
    t.index "ll_to_earth((latitude)::double precision, (longitude)::double precision)", name: "users_earthdistance_ix", using: :gist
    t.index ["city_id"], name: "index_users_on_city_id", using: :btree
    t.index ["country_id"], name: "index_users_on_country_id", using: :btree
    t.index ["domain"], name: "index_users_on_domain", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["plan_id"], name: "index_users_on_plan_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "cities", "countries"
  add_foreign_key "cities", "states"
  add_foreign_key "cities", "timezones"
  add_foreign_key "countries", "continents"
  add_foreign_key "invitations", "users", column: "inviter_id", on_delete: :cascade
  add_foreign_key "projects", "users", on_delete: :cascade
  add_foreign_key "states", "countries"
  add_foreign_key "timezones", "countries"
  add_foreign_key "users", "cities"
  add_foreign_key "users", "countries"
  add_foreign_key "users", "plans"
end
