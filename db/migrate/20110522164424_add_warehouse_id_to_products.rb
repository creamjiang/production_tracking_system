class AddWarehouseIdToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :warehouse_id, :integer, :default => 0
    add_index :products, :warehouse_id
    remove_column :routing_procedures, :warehouse_id
  end

  def self.down
    remove_index :products, :warehouse_id
    remove_column :products, :warehouse_id
  end
end
