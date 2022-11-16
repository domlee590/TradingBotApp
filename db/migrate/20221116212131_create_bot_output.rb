class CreateBotOutput < ActiveRecord::Migration[7.0]
  def change
    create_table :bot_outputs do |t|
      t.integer :bot_id
      t.float :pnl
      t.float :wr
      t.integer :tc
      t.string :desc

      t.timestamps
    end

    add_foreign_key :bot_outputs, :bots, column: :bot_id, primary_key: :id
  end
end
