class Rename < ActiveRecord::Migration[7.0]
  def change
    rename_column :bot_outputs, :desc, :description
  end
end
