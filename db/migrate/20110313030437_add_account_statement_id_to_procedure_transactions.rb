class AddAccountStatementIdToProcedureTransactions < ActiveRecord::Migration
  def self.up
    #add_column :procedure_transactions, :account_statement_id, :integer, :default => 0
    #add_index :procedure_transactions, :account_statement_id
  end

  def self.down
    #remove_index :procedure_transactions, :account_statement_id
    #remove_column :procedure_transactions, :account_statement_id
  end
end
