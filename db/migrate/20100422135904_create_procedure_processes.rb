class CreateProcedureProcesses < ActiveRecord::Migration
  def self.up
    create_table :procedure_processes do |t|
      t.integer :routing_procedure_id, :default => 0
      t.integer :routing_process_id, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :procedure_processes
  end
end
