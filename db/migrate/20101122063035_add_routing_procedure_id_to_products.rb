class AddRoutingProcedureIdToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :routing_procedure_id, :integer, :null => false
    add_index :products, :routing_procedure_id
  end

  def self.down
    remove_index :products, :routing_procedure_id
    remove_column :products, :routing_procedure_id
  end
end
