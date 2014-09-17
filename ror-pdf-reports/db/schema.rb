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

ActiveRecord::Schema.define(version: 20140917163848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "enterprises", primary_key: "enterprise_id", force: true do |t|
    t.string   "enterprise_ticker", limit: 50
    t.string   "enterprise_name",   limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "infosel_stock_actions", primary_key: "action_id", force: true do |t|
    t.integer  "buyer_id"
    t.integer  "seller_id"
    t.integer  "volume"
    t.decimal  "price",          precision: 5,  scale: 2
    t.decimal  "total",          precision: 10, scale: 2
    t.datetime "time_stamp"
    t.integer  "stock_owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mediators", primary_key: "mediator_id", force: true do |t|
    t.string   "mediator_name", limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "yahoo_stock_actions", primary_key: "action_id", force: true do |t|
    t.date     "date"
    t.decimal  "open",           precision: 5, scale: 2
    t.decimal  "high",           precision: 5, scale: 2
    t.decimal  "low",            precision: 5, scale: 2
    t.decimal  "close",          precision: 5, scale: 2
    t.integer  "volume"
    t.decimal  "adj_close",      precision: 5, scale: 2
    t.integer  "stock_owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "infosel_stock_actions", "enterprises", name: "infosel_stock_actions_stock_owner_id_fkey", column: "stock_owner_id", primary_key: "enterprise_id", dependent: :delete
  add_foreign_key "infosel_stock_actions", "mediators", name: "infosel_stock_actions_buyer_id_fkey", column: "buyer_id", primary_key: "mediator_id", dependent: :delete
  add_foreign_key "infosel_stock_actions", "mediators", name: "infosel_stock_actions_seller_id_fkey", column: "seller_id", primary_key: "mediator_id", dependent: :delete

  add_foreign_key "yahoo_stock_actions", "enterprises", name: "yahoo_stock_actions_stock_owner_id_fkey", column: "stock_owner_id", primary_key: "enterprise_id", dependent: :delete

end
