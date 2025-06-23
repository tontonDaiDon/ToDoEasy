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

ActiveRecord::Schema[7.1].define(version: 2025_06_23_133619) do
  create_table "items", force: :cascade do |t|
    t.string "name"
    t.integer "quantity"
    t.integer "price"
    t.boolean "purchased"
    t.integer "shopping_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopping_list_id"], name: "index_items_on_shopping_list_id"
  end

  create_table "purchase_histories", force: :cascade do |t|
    t.integer "shopping_list_id", null: false
    t.date "purchased_on"
    t.integer "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopping_list_id"], name: "index_purchase_histories_on_shopping_list_id"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.string "title"
    t.integer "budget"
    t.date "shopped_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  add_foreign_key "items", "shopping_lists"
  add_foreign_key "purchase_histories", "shopping_lists"
end
