class CreateBots < ActiveRecord::Migration[7.0]
  def change
    create_table :bots do |t|
      t.string :name
      t.integer :movingAverage1
      t.integer :movingAverage2
      t.boolean :short
      t.datetime :created
      t.timestamps
    end
  end
end
