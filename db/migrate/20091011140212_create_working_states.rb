class CreateWorkingStates < ActiveRecord::Migration
  def self.up
    create_table :working_states do |t|
      t.integer :product_id
      t.integer :bin_id
      t.integer :machine_id
      t.integer :routing_procedure_id
      t.integer :employee_id
      t.integer :good_unit, :default => 0
      t.integer :reject_unit, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :working_states
  end
end
