# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_02_13_172455) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banks", force: :cascade do |t|
    t.string "name", null: false
    t.string "bic", null: false
    t.string "iban", null: false
    t.boolean "is_default", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_banks_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "address1"
    t.string "address2"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "days", force: :cascade do |t|
    t.date "date", null: false
    t.boolean "worked", default: true
    t.string "comment"
    t.bigint "invoice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_days_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id", null: false
    t.string "number", null: false
    t.date "date", null: false
    t.string "title"
    t.bigint "user_id", null: false
    t.boolean "locked", default: false
    t.datetime "deleted_at"
    t.bigint "bank_id", null: false
    t.integer "flavor", default: 0, null: false
    t.string "seller_name"
    t.string "seller_address1"
    t.string "seller_zipcode"
    t.string "seller_city"
    t.string "seller_country"
    t.string "seller_email"
    t.string "seller_website"
    t.string "seller_siren"
    t.string "client_name"
    t.string "client_address1"
    t.string "client_address2"
    t.string "client_zipcode"
    t.string "client_city"
    t.string "client_country"
    t.boolean "advance", default: false, null: false
    t.index ["bank_id"], name: "index_invoices_on_bank_id"
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.bigint "invoice_id"
    t.text "description", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "quote_id"
    t.index ["invoice_id"], name: "index_line_items_on_invoice_id"
    t.index ["quote_id"], name: "index_line_items_on_quote_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.string "title"
    t.string "client_name", null: false
    t.date "date", null: false
    t.jsonb "description_blocks", default: [], array: true
    t.integer "flavor", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "client_address1"
    t.string "client_address2"
    t.string "client_zipcode"
    t.string "client_city"
    t.string "client_country"
    t.boolean "with_agreement", default: false
    t.string "number"
    t.index ["user_id"], name: "index_quotes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address1"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.string "website"
    t.string "siren"
    t.string "first_name"
    t.string "last_name"
    t.integer "genre"
    t.string "username"
    t.datetime "deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "banks", "users"
  add_foreign_key "clients", "users"
  add_foreign_key "days", "invoices"
  add_foreign_key "invoices", "banks"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "users"
  add_foreign_key "line_items", "invoices"
  add_foreign_key "line_items", "quotes"
  add_foreign_key "quotes", "users"
end
