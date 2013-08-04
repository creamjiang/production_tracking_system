class AddTransferedQuantityToExportItems < ActiveRecord::Migration
  def self.up
    add_column :export_items, :transfered_quantity, :integer, :default => 0
  end

  def self.down
    remove_column :export_items, :transfered_quantity
  end
end
