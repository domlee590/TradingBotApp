class Init < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.timestamps
    end


    create_table :bots do |t|
      t.string :name
      t.string :username
      t.boolean :short
      t.timestamps
      t.integer :ema
      t.integer :bb
      t.integer :sma
      t.integer :vwap
      t.string :symbol
      t.boolean :macd
      t.boolean :sar
      t.boolean :rsi
    end

    create_table :edus do |t|
      t.string :channel
      t.string :youtube_id
      t.string :link
      t.string :description
      t.string :name
      t.string :username
      t.boolean :short
      t.timestamps
      t.integer :ema
      t.integer :bb
      t.integer :sma
      t.integer :vwap
      t.string :symbol
      t.boolean :macd
      t.boolean :sar
      t.boolean :rsi
      t.boolean :run
    end

    create_table :edu_outs do |t|
      t.integer :edu_id
      t.integer :time
      t.float :pnl
      t.float :wr
      t.integer :tc
    end

    create_table "bot_outs", force: :cascade do |t|
      t.integer "bot_id"
      t.integer "time"
      t.float "pnl"
      t.float "wr"
      t.integer "tc"
      t.integer "status", default: 0
      t.float "pre_pnl", default: 0
      t.integer "won", default: 0
      t.float "balance", default: 100
      t.float "amount_traded", default: 0
      t.float "traded_qty", default: 0
      t.float "entry_price", default: 0
      t.datetime "created_at", null: false
    end

    add_index :users, :username, unique: true

    add_foreign_key :bots, :users, column: :username, primary_key: :username
    add_foreign_key :edu_outs, :edus, column: :edu_id, primary_key: :id
    add_foreign_key :bot_outs, :bots, column: :bot_id, primary_key: :id
    add_index :bot_outs, [:bot_id, :time], unique: true
    add_index :edu_outs, [:edu_id, :time], unique: true

  end
end
