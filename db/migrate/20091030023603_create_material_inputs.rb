class CreateMaterialInputs < ActiveRecord::Migration
  def self.up
    create_table :material_inputs do |t|
      t.integer :machine_id
      t.integer :material_id
      t.string :lot_number, :limit => 45
      t.integer :quantity, :default => 0
      t.string :uom, :limit => 20
      t.datetime :start_time
      t.datetime :finish_time
      t.date :input_date

      t.timestamps
    end
  end

  def self.down
    drop_table :material_inputs
  end
end
