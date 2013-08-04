class AddRoutingProcedureIdToAttachedProducts < ActiveRecord::Migration
  def self.up
    add_column :attached_products, :routing_procedure_id, :integer
    add_column :attached_products, :routing_id, :integer
    add_column :attached_products, :routing_process_id, :integer
    add_index :attached_products, :routing_procedure_id
    add_index :attached_products, :routing_id
    add_index :attached_products, :routing_process_id
  end

  def self.down
    remove_index :attached_products, :routing_procedure_id
    remove_index :attached_products, :routing_id
    remove_index :attached_products, :routing_process_id
    remove_column :attached_products, :routing_procedure_id
    remove_column :attached_products, :routing_id
    remove_column :attached_products, :routing_process_id
  end
end
