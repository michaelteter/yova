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

ActiveRecord::Schema.define(version: 2021_03_16_114257) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "asset_performances", force: :cascade do |t|
    t.bigint "company_id"
    t.date "ticker_date", null: false
    t.decimal "return_1_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "return_30_days"
    t.decimal "return_1_cal_mo"
    t.decimal "return_mtd"
    t.decimal "return_ytd"
    t.index ["company_id", "ticker_date"], name: "index_asset_performances_on_company_id_and_ticker_date", unique: true
    t.index ["company_id"], name: "index_asset_performances_on_company_id"
    t.index ["ticker_date"], name: "index_asset_performances_on_ticker_date"
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

  create_table "notification_alerts", force: :cascade do |t|
    t.string "purpose"
    t.string "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "uuid", limit: 36, null: false
    t.bigint "client_id"
    t.datetime "notified_at"
    t.datetime "fetched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "notification_alert_id"
    t.index ["client_id"], name: "index_notifications_on_client_id"
    t.index ["notification_alert_id"], name: "index_notifications_on_notification_alert_id"
  end

  create_table "portfolio_performances", force: :cascade do |t|
    t.decimal "twr_1_cal_mo"
    t.decimal "twr_30_days"
    t.date "period_end", null: false
    t.jsonb "assets_data", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "twr_mtd"
    t.decimal "twr_ytd"
    t.decimal "twr_1_day"
    t.bigint "client_id"
    t.index ["client_id", "period_end"], name: "index_portfolio_performances_on_client_id_and_period_end", unique: true
    t.index ["client_id"], name: "index_portfolio_performances_on_client_id"
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
    t.date "ticker_date", null: false
    t.decimal "open", precision: 12, scale: 4
    t.decimal "high", precision: 12, scale: 4
    t.decimal "low", precision: 12, scale: 4
    t.decimal "close", precision: 12, scale: 4, null: false
    t.bigint "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.index ["company_id", "ticker_date"], name: "index_timeseries_on_company_id_and_ticker_date", unique: true
    t.index ["company_id"], name: "index_timeseries_on_company_id"
    t.index ["symbol", "ticker_date"], name: "index_timeseries_on_symbol_and_ticker_date", unique: true
    t.index ["symbol"], name: "index_timeseries_on_symbol"
    t.index ["ticker_date"], name: "index_timeseries_on_ticker_date"
  end

  add_foreign_key "asset_performances", "companies"
  add_foreign_key "notifications", "clients"
  add_foreign_key "notifications", "notification_alerts"
  add_foreign_key "portfolio_performances", "clients"
  add_foreign_key "portfolios", "clients"
  add_foreign_key "portfolios", "companies"
  add_foreign_key "timeseries", "companies"
end
