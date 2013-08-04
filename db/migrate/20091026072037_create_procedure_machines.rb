class CreateProcedureMachines < ActiveRecord::Migration
  def self.up
    create_table :procedure_machines do |t|
      t.integer :routing_procedure_id
      t.integer :machine_id

      t.timestamps
    end
  end

  def self.down
    drop_table :procedure_machines
  end
end
