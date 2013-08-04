class AddProductIdToExportItems < ActiveRecord::Migration
  def self.up
    add_column :export_items, :product_id, :integer, :null => false
    add_index :export_items, :product_id
  end

  def self.down
    remove_index :export_items, :product_id
    remove_column :export_items, :product_id
  end
end
