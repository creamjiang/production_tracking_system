class AddGenericNameIndexToProcedureTransactions < ActiveRecord::Migration
  def self.up
     add_index :procedure_transactions, :generic_name
     add_index :procedure_transactions, :quantity
  end

  def self.down
  end
end
