class RemoveWarehouseIdFromAttachedProducts < ActiveRecord::Migration
  def self.up
    remove_column :attached_products, :warehouse_id
    remove_column :attached_products, :reject_include
  end

  def self.down
  end
end
