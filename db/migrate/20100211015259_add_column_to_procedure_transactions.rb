class AddColumnToProcedureTransactions < ActiveRecord::Migration
  def self.up
    add_column :procedure_transactions, :quantity, :integer, :default => 1
    add_column :procedure_transactions, :generic_name, :string, :limit => 90, :default => 'None'
  end

  def self.down
    remove_column :procedure_transactions, :generic_name
    remove_column :procedure_transactions, :quantity
  end
end
