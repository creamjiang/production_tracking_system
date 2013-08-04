class RemoveBalanceAndAccountStatementIdFromProcedureTransactions < ActiveRecord::Migration
  def self.up
    remove_column(:procedure_transactions, :balance)
    remove_index(:procedure_transactions, :account_statement_id)
    remove_column(:procedure_transactions, :account_statement_id)
  end

  def self.down
  end
end
