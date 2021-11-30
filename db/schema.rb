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

ActiveRecord::Schema.define(version: 2021_11_25_112949) do

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "position"
    t.integer "id_location_id"
    t.integer "id_project_id"
    t.index ["id_location_id"], name: "index_employees_on_id_location_id"
    t.index ["id_project_id"], name: "index_employees_on_id_project_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

  add_foreign_key "employees", "locations", column: "id_location_id"
  add_foreign_key "employees", "projects", column: "id_project_id"
end
