class AddIndexToTables < ActiveRecord::Migration[7.0]
  def change
    add_index :bots, :email, unique: true
    add_index :users, :email, unique: true
  end
end
