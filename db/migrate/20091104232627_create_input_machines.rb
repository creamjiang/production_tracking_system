class CreateInputMachines < ActiveRecord::Migration
  def self.up
    create_table :input_machines do |t|
      t.integer :machine_id
      t.integer :material_input_id

      t.timestamps
    end
  end

  def self.down
    drop_table :input_machines
  end
end
