class AddWarehouseIdToExportItems < ActiveRecord::Migration
  def self.up
    add_column :export_items, :warehouse_id, :integer, :default => 0
    add_index :export_items, :warehouse_id
  end

  def self.down
    remove_index :export_items, :warehouse_id
    remove_column :export_items, :warehouse_id
  end
end

