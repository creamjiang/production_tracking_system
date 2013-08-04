class AddSuspendToProcedureMachines < ActiveRecord::Migration
  def self.up
    add_column :procedure_machines, :suspend, :boolean, :default => false
  end

  def self.down
    remove_column :procedure_machines, :suspend
  end
end
