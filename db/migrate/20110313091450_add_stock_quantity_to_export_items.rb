class AddStockQuantityToExportItems < ActiveRecord::Migration
  def self.up
    add_column :export_items, :stock_quantity, :integer, :default => 0
    add_column :export_items, :posted, :boolean, :default => false
    add_index :export_items, :posted
  end

  def self.down
    remove_index :export_items, :posted
    remove_column :export_items, :posted
    remove_column :export_items, :stock_quantity
  end
end
