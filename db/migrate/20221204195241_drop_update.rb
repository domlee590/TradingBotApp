class DropUpdate < ActiveRecord::Migration[7.0]
  def change
    remove_column :bot_outs, :updated_at
  end
end
