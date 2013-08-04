class AddAccountStatementIdToExportItems < ActiveRecord::Migration
  def self.up
    add_column :export_items, :account_statement_id, :integer, :null => false
    add_index :export_items, :account_statement_id
  end

  def self.down
    remove_index :export_items, :account_statement_id
    remove_column :export_items, :account_statement_id
  end
end
