class AddAdminIdToColdStore < ActiveRecord::Migration
  def self.up
    add_column :cold_stores, :administrator_id, :integer, :default => 0
  end

  def self.down
    remove_column :cold_stores, :administrator_id
  end
end
