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

ActiveRecord::Schema.define(version: 2021_03_14_005054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_notifications", force: :cascade do |t|
    t.string "uuid", limit: 36, null: false
    t.bigint "notification_id"
    t.bigint "client_id"
    t.datetime "notified_at"
    t.datetime "fetched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_notifications_on_client_id"
    t.index ["notification_id"], name: "index_client_notifications_on_notification_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "uuid", limit: 36, null: false
    t.string "notification_method"
    t.string "notification_target"
    t.string "public_key"
    t.string "api_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_clients_on_name"
  end

  create_table "companies", force: :cascade do |t|
    t.string "symbol", limit: 20, null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "purpose"
    t.string "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "company_id", null: false
    t.decimal "weight", precision: 12, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "company_id"], name: "index_portfolios_on_client_id_and_company_id", unique: true
    t.index ["client_id"], name: "index_portfolios_on_client_id"
    t.index ["company_id"], name: "index_portfolios_on_company_id"
  end

  create_table "timeseries", force: :cascade do |t|
    t.string "symbol", limit: 20, null: false
    t.date "ticker_date"
    t.decimal "open", precision: 12, scale: 4
    t.decimal "high", precision: 12, scale: 4
    t.decimal "low", precision: 12, scale: 4
    t.decimal "close", precision: 12, scale: 4, null: false
    t.bigint "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["symbol", "ticker_date"], name: "index_timeseries_on_symbol_and_ticker_date", unique: true
    t.index ["symbol"], name: "index_timeseries_on_symbol"
    t.index ["ticker_date"], name: "index_timeseries_on_ticker_date"
  end

  add_foreign_key "client_notifications", "clients"
  add_foreign_key "client_notifications", "notifications"
  add_foreign_key "portfolios", "clients"
  add_foreign_key "portfolios", "companies"
end
