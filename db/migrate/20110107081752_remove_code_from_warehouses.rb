class RemoveCodeFromWarehouses < ActiveRecord::Migration
  def self.up
    remove_column(:warehouses, :code)
    add_column :routing_procedures, :warehouse, :string
    add_column :routing_procedures, :location, :string
  end

  def self.down
    add_column(:warehouses, :code, :string)
    remove_column :routing_procedures, :warehouse
    remove_column :routing_procedures, :location
  end
end
