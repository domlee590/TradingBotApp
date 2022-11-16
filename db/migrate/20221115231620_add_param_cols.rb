class AddParamCols < ActiveRecord::Migration[7.0]
  def change
    add_column :bots, :ema, :integer
    add_column :bots, :bb, :integer
    add_column :bots, :rsi, :integer
    add_column :bots, :sma, :integer
    add_column :bots, :macd, :integer
    add_column :bots, :sar, :integer
    add_column :bots, :vwap, :integer
    add_column :bots, :crossover, :string
    add_column :bots, :symbol, :string
  end
end
