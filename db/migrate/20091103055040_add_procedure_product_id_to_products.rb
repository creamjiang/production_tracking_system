class AddProcedureProductIdToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :procedure_product_id, :integer
  end

  def self.down
    remove_column :products, :procedure_product_id
  end
end
