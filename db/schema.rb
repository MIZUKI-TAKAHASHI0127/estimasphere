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

ActiveRecord::Schema[7.0].define(version: 2023_09_03_201944) do
  create_table "categories", charset: "utf8", force: :cascade do |t|
    t.string "category_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_name"], name: "index_categories_on_category_name", unique: true
  end

  create_table "company_infos", charset: "utf8", force: :cascade do |t|
    t.string "company_name", null: false
    t.string "postcode", null: false
    t.string "address", null: false
    t.string "phone_number", null: false
    t.string "fax_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", charset: "utf8", force: :cascade do |t|
    t.string "customer_code"
    t.string "customer_name", null: false
    t.string "address", null: false
    t.string "phone_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_code"], name: "index_customers_on_customer_code", unique: true
  end

  create_table "purchase_quotation_items", charset: "utf8", force: :cascade do |t|
    t.bigint "purchase_quotation_id", null: false
    t.string "item_name", null: false
    t.integer "quantity", null: false
    t.bigint "category_id", null: false
    t.bigint "unit_id", null: false
    t.integer "unit_price", null: false
    t.string "note"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_purchase_quotation_items_on_category_id"
    t.index ["unit_id"], name: "index_purchase_quotation_items_on_unit_id"
  end

  create_table "purchase_quotations", charset: "utf8", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "user_id", null: false
    t.string "quotation_number", null: false
    t.date "request_date", null: false
    t.date "quotation_date", null: false
    t.date "quotation_due_date", null: false
    t.date "delivery_date", null: false
    t.string "handover_place"
    t.string "trading_conditions"
    t.integer "representative_id"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_purchase_quotations_on_customer_id"
    t.index ["quotation_number"], name: "index_purchase_quotations_on_quotation_number", unique: true
    t.index ["user_id"], name: "index_purchase_quotations_on_user_id"
  end

  create_table "representatives", charset: "utf8", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "department_name"
    t.string "representative_name"
    t.string "phone_number"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_representatives_on_customer_id"
  end

  create_table "sales_quotation_items", charset: "utf8", force: :cascade do |t|
    t.bigint "sales_quotation_id", null: false
    t.string "item_name", null: false
    t.integer "quantity", null: false
    t.bigint "category_id", null: false
    t.bigint "unit_id", null: false
    t.integer "unit_price", null: false
    t.string "note"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_sales_quotation_items_on_category_id"
    t.index ["unit_id"], name: "index_sales_quotation_items_on_unit_id"
  end

  create_table "sales_quotations", charset: "utf8", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "user_id", null: false
    t.string "quotation_number", null: false
    t.date "request_date", null: false
    t.date "quotation_date", null: false
    t.date "quotation_due_date", null: false
    t.date "delivery_date", null: false
    t.string "delivery_place"
    t.string "trading_conditions"
    t.integer "representative_id"
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_sales_quotations_on_customer_id"
    t.index ["quotation_number"], name: "index_sales_quotations_on_quotation_number", unique: true
    t.index ["user_id"], name: "index_sales_quotations_on_user_id"
  end

  create_table "units", charset: "utf8", force: :cascade do |t|
    t.string "unit_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_name"], name: "index_units_on_unit_name", unique: true
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "last_name", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "purchase_quotation_items", "categories"
  add_foreign_key "purchase_quotation_items", "units"
  add_foreign_key "purchase_quotations", "customers"
  add_foreign_key "purchase_quotations", "users"
  add_foreign_key "representatives", "customers"
  add_foreign_key "sales_quotation_items", "categories"
  add_foreign_key "sales_quotation_items", "units"
  add_foreign_key "sales_quotations", "customers"
  add_foreign_key "sales_quotations", "users"
end
