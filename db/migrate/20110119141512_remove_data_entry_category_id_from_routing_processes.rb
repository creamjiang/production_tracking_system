class RemoveDataEntryCategoryIdFromRoutingProcesses < ActiveRecord::Migration
  def self.up
    remove_index(:routing_processes, :entry_category_id)
    remove_column(:routing_processes, :entry_category_id)
    remove_index :warehouses, :routing_procedure_id
    remove_column(:warehouses, :routing_procedure_id)
    remove_column(:routing_procedures, :warehouse)
    remove_column(:routing_procedures, :location)
    add_column(:routing_procedures, :warehouse_id, :integer, :default => 1, :null => false)
    add_index(:routing_procedures, :warehouse_id)
  end

  def self.down
  end
end
