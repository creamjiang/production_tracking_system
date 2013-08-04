class CreateMachines < ActiveRecord::Migration
  def self.up
    create_table :machines do |t|
      t.string :machine_number, :limit => 45
      t.string :asset_number, :limit => 45
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :machines
  end
end
