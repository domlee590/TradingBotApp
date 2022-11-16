class DropAts < ActiveRecord::Migration[7.0]
  def change
    remove_column :bot_outputs, :created_at
    remove_column :bot_outputs, :updated_at
  end
end
