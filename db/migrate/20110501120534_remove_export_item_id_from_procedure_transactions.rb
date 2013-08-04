class RemoveExportItemIdFromProcedureTransactions < ActiveRecord::Migration
  def self.up
    remove_column(:procedure_transactions, :export_item_id)
  end

  def self.down
  end
end
