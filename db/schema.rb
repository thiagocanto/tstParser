# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_07_191734) do

  create_table "customers", force: :cascade do |t|
    t.string "external_code"
    t.string "name"
    t.string "email"
    t.string "contact"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "integration_processes", force: :cascade do |t|
    t.string "external_code"
    t.integer "store_id"
    t.float "sub_total"
    t.float "delivery_fee"
    t.float "total"
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "district"
    t.string "street"
    t.string "complement"
    t.float "latitude"
    t.float "longitude"
    t.datetime "dt_order_create"
    t.string "postal_code"
    t.string "number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "customer_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "integration_process_id"
    t.integer "items_id"
    t.string "external_code"
    t.string "name"
    t.float "price"
    t.integer "quantity"
    t.float "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["integration_process_id"], name: "index_items_on_integration_process_id"
    t.index ["items_id"], name: "index_items_on_items_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "integration_process_id"
    t.string "payment_type"
    t.float "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["integration_process_id"], name: "index_payments_on_integration_process_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "integration_processes", "customers", on_delete: :cascade
  add_foreign_key "integration_processes", "stores", on_delete: :cascade
end
