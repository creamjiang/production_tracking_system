class AddRoutingIdToExportItems < ActiveRecord::Migration
  def self.up
    add_column :export_items, :routing_id, :integer, :null => false
    add_column :export_items, :routing_process_id, :integer, :null => false
    add_index :export_items, :routing_id
    add_index :export_items, :routing_process_id
  end

  def self.down
    remove_index :export_items, :routing_id
    remove_index :export_items, :routing_process_id
    remove_column :export_items, :routing_process_id
    remove_column :export_items, :routing_id
  end
end
