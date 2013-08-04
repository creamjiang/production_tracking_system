class AddShiftToProcedureTransaction < ActiveRecord::Migration
  def self.up
    add_column :procedure_transactions, :shift_id, :integer, :default => 0
  end

  def self.down
    remove_column :procedure_transactions, :shift_id
  end
end
