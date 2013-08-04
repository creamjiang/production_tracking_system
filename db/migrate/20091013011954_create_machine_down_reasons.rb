class CreateMachineDownReasons < ActiveRecord::Migration
  def self.up
    create_table :machine_down_reasons do |t|
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :machine_down_reasons
  end
end
