class AddProductToRoutingProcedure < ActiveRecord::Migration
  def self.up
    add_column :routing_procedures, :product_id, :integer
  end

  def self.down
    remove_column :routing_procedures, :product_id, :integer
  end
end
