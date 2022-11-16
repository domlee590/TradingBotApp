class AddFk < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :bots, :users, column: :email, primary_key: :email
  end
end
