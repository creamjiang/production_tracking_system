class CreateWarehouses < ActiveRecord::Migration
  def self.up
    create_table :warehouses do |t|
      t.integer :routing_procedure_id, :default => 0
      t.string :name, :limit => 45
      t.string :location, :limit => 45
      t.string :code, :limit => 10
      t.string :remark

      t.timestamps
    end
    add_index :warehouses, :routing_procedure_id
  end

  def self.down
    drop_table :warehouses
  end
end
