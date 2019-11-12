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

ActiveRecord::Schema.define(version: 2019_11_11_214104) do

  create_table "bills", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "primary_subject"
    t.string "sponsor_id"
    t.integer "cosponsor_total"
    t.integer "cosponsor_d"
    t.integer "cosponsor_r"
    t.integer "cosponsor_i"
    t.boolean "active"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "house_members", force: :cascade do |t|
    t.string "full_name"
    t.string "first_name"
    t.string "last_name"
    t.string "state"
    t.string "party"
    t.string "district"
    t.string "next_election"
    t.string "url"
    t.string "phone"
    t.float "votes_with_party_pct"
    t.float "votes_against_party_pct"
    t.float "missed_votes_pct"
    t.string "api_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "senators", force: :cascade do |t|
    t.string "full_name"
    t.string "first_name"
    t.string "last_name"
    t.string "state"
    t.string "party"
    t.string "state_rank"
    t.string "next_election"
    t.string "url"
    t.string "phone"
    t.float "votes_with_party_pct"
    t.float "votes_against_party_pct"
    t.float "missed_votes_pct"
    t.string "api_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer "member_id"
    t.integer "bill_id"
    t.datetime "vote_date"
    t.string "vote"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
