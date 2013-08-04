class RestoreAllPreviousColumns < ActiveRecord::Migration
  def self.up
    remove_index :products, :warehouse_id
    remove_column :products, :warehouse_id
    add_column :attached_products, :warehouse_id, :integer, :default => 0

    remove_column :routing_procedures, :reject_include
    add_column :attached_products, :reject_include, :boolean, :default => false

    add_column(:product_balances, :routing_id, :integer, :default => 0)
    add_column(:product_balances, :routing_process_id, :integer, :default => 0)
    add_column(:product_balances, :routing_procedure_id, :integer, :default => 0)
    add_index(:product_balances, :routing_id)
    add_index(:product_balances, :routing_process_id)
    add_index(:product_balances, :routing_procedure_id)
  end

  def self.down
  end
end
