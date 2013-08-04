class RemoveRoutingProcedureIdFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :routing_procedure_id
    remove_index :products, :routing_procedure_id

  end

  def self.down
  end
end
