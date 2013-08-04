class AddRoutingIdToProcedureMachines < ActiveRecord::Migration
  def self.up
    add_column :procedure_machines, :routing_id, :integer
  end

  def self.down
    remove_column :procedure_machines, :routing_id
  end
end
