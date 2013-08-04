class AddExportItemIdToProcedureTransactions < ActiveRecord::Migration
  def self.up
#    add_column :procedure_transactions, :export_item_id, :integer, :default => 0
#    add_index :procedure_transactions, :export_item_id
  end

  def self.down
#    remove_index :procedure_transactions, :export_item_id
#    remove_column :procedure_transactions, :export_item_id
  end
end
