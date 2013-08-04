class CreateRoutineProducts < ActiveRecord::Migration
  def self.up
    create_table :routine_products do |t|
      t.integer :routing_procedure_id, :default => 0
      t.integer :product_id, :default => 0
      t.integer :warehouse_id, :default => 0
      t.boolean :reject_include, :default => false
      t.integer :bin_type_id, :default => 0

      t.timestamps
    end
    add_index :routine_products, :routing_procedure_id
    add_index :routine_products, :product_id
    add_index :routine_products, :warehouse_id
    add_index :routine_products, :bin_type_id
  end

  def self.down
    drop_table :routine_products
  end
end
