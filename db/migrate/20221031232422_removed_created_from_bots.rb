class RemovedCreatedFromBots < ActiveRecord::Migration[7.0]
  def up
    remove_column :bots, :created
  end
end
