class CreateExportItems < ActiveRecord::Migration
  def self.up
    create_table :export_items do |t|
      t.integer :prms_export_id, :null => false
      t.integer :routing_procedure_id, :null => false
      t.integer :warehouse_id, :null => false
      t.integer :export_quantity, :default => 0

      t.timestamps
    end
    add_index :export_items, :prms_export_id
    add_index :export_items, :routing_procedure_id
    add_index :export_items, :warehouse_id
  end

  def self.down
    remove_index :export_items, :prms_export_id
    remove_index :export_items, :routing_procedure_id
    remove_index :export_items, :warehouse_id
    drop_table :export_items
  end
end
