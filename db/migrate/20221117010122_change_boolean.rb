class ChangeBoolean < ActiveRecord::Migration[7.0]
  def change
    remove_column :bots, :rsi
    remove_column :bots, :macd
    remove_column :bots, :sar
    add_column :bots, :rsi, :boolean
    add_column :bots, :macd, :boolean
    add_column :bots, :sar, :boolean
  end
end
