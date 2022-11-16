class Drop < ActiveRecord::Migration[7.0]
  def change
    remove_column :bots, :movingAverage1
    remove_column :bots, :movingAverage2
  end
end
