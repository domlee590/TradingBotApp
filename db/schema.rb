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

ActiveRecord::Schema[7.0].define(version: 2022_12_04_195241) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bot_outs", force: :cascade do |t|
    t.integer "bot_id"
    t.integer "time"
    t.float "pnl"
    t.float "wr"
    t.integer "tc"
    t.datetime "created_at", null: false
  end

  create_table "bots", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.boolean "short"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ema"
    t.integer "bb"
    t.integer "sma"
    t.integer "vwap"
    t.string "symbol"
    t.boolean "macd"
    t.boolean "sar"
    t.boolean "rsi"
  end

  create_table "edu_outs", force: :cascade do |t|
    t.integer "edu_id"
    t.integer "time"
    t.float "pnl"
    t.float "wr"
    t.integer "tc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "edus", force: :cascade do |t|
    t.string "channel"
    t.string "youtube_id"
    t.string "link"
    t.string "description"
    t.string "name"
    t.string "username"
    t.boolean "short"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ema"
    t.integer "bb"
    t.integer "sma"
    t.integer "vwap"
    t.string "symbol"
    t.boolean "macd"
    t.boolean "sar"
    t.boolean "rsi"
    t.boolean "run"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "bot_outs", "bots"
  add_foreign_key "bots", "users", column: "username", primary_key: "username"
  add_foreign_key "edu_outs", "edus"
end
