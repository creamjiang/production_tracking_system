class AddMonthYearToAccountStatements < ActiveRecord::Migration
  def self.up
    add_column :account_statements, :account_month, :integer, :default => 1, :null => false
    add_column :account_statements, :account_year, :year, :default => '2010', :null => false
    add_index :account_statements, :account_month
    add_index :account_statements, :account_year
    add_index :account_statements, :routing_id
    add_index :account_statements, :routing_process_id
    add_index :account_statements, :routing_procedure_id
    add_index :account_statements, :product_id
  end

  def self.down
    remove_column :account_statements, :account_year
    remove_column :account_statements, :account_month
    remove_index :account_statements, :account_month
    remove_index :account_statements, :account_year
    remove_index :account_statements, :routing_id
    remove_index :account_statements, :routing_process_id
    remove_index :account_statements, :routing_procedure_id
    remove_index :account_statements, :product_id
  end
end
