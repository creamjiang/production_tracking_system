class RemoveProductIdFromProcedureProducts < ActiveRecord::Migration
  def self.up
    remove_column(:procedure_products, :routing_process_id)
    remove_column(:procedure_products, :product_id)
  end

  def self.down
    add_column(:procedure_products, :routing_process_id, :integer)
    add_column(:procedure_products, :product_id, :integer)
  end
end

