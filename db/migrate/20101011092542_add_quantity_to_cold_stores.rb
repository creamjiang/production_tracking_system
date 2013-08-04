class AddQuantityToColdStores < ActiveRecord::Migration
  def self.up
    add_column :cold_stores, :quantity, :integer, :default => 0
  end

  def self.down
    remove_column :cold_stores, :quantity
  end
end
