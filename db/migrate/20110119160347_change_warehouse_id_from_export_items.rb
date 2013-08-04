class ChangeWarehouseIdFromExportItems < ActiveRecord::Migration
  def self.up
    remove_index :export_items, :warehouse_id
    rename_column(:export_items, :warehouse_id, :destination_id)
    add_index :export_items, :destination_id
  end

  def self.down
  end
end
