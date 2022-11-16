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
      t.integer :rsi
      t.integer :sma
      t.integer :macd
      t.integer :sar
      t.integer :vwap
      t.string :symbol
    end

    add_index :users, :username, unique: true

    add_foreign_key :bots, :users, column: :username, primary_key: :username
  end
end
