class AddBalanceToProcedureTransactions < ActiveRecord::Migration
  def self.up
#    add_column :procedure_transactions, :balance, :integer, :default => 0
#    add_index :procedure_transactions, :balance
#    ProcedureTransaction.reset_column_information
#    ProcedureTransaction.find_each do |p|
#      p.balance = p.quantity
#      p.save!
#    end
  end

  def self.down
#    remove_index :procedure_transactions, :balance
#    remove_column :procedure_transactions, :balance
  end
end
