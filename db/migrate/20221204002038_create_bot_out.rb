class CreateBotOut < ActiveRecord::Migration[7.0]
  def change
    create_table :bot_outs do |t|
      t.integer :bot_id
      t.integer :time
      t.float :pnl
      t.float :wr
      t.integer :tc
      t.timestamps
    end

    add_foreign_key :bot_outs, :bots, column: :bot_id, primary_key: :id
  end
end
