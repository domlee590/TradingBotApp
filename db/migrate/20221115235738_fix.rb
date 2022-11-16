class Fix < ActiveRecord::Migration[7.0]
  def change
    add_column :bots, :email, :string
  end
end
