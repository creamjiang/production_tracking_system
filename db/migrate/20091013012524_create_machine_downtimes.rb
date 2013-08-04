class CreateMachineDowntimes < ActiveRecord::Migration
  def self.up
    create_table :machine_downtimes do |t|
      t.integer :machine_id, :default => 0
      t.integer :employee_id, :default => 0
      t.integer :routing_id, :default => 0
      t.integer :routing_process_id, :default => 0
      t.integer :routing_procedure_id, :default => 0
      t.integer :bin_id, :default => 0
      t.integer :bin_type_id, :default => 0
      t.integer :product_id, :default => 0
      t.integer :machine_down_reason_id, :default => 0
      t.integer :container_id, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :machine_downtimes
  end
end
