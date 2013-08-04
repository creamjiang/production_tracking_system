class RemoveRoutingProcedureFromProductBalances < ActiveRecord::Migration
  def self.up
    remove_index(:product_balances, :routing_id)
    remove_index(:product_balances, :routing_process_id)
    remove_index(:product_balances, :routing_procedure_id)
    remove_column(:product_balances, :routing_id)
    remove_column(:product_balances, :routing_process_id)
    remove_column(:product_balances, :routing_procedure_id)
  end

  def self.down
  end
end
