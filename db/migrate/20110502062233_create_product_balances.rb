class CreateProductBalances < ActiveRecord::Migration
  def self.up
    create_table :product_balances do |t|
      t.integer :routing_id, :null => false
      t.integer :routing_process_id, :null => false
      t.integer :routing_procedure_id, :null => false
      t.integer :product_id, :null => false
      t.string :generic_name, :null => false
      t.integer :quantity_in, :default => 0
      t.integer :quantity_out, :default => 0
      t.integer :balance, :default => 0

      t.timestamps
    end
    add_index :product_balances, :routing_id
    add_index :product_balances, :routing_process_id
    add_index :product_balances, :routing_procedure_id
    add_index :product_balances, :product_id
    add_index :product_balances, :balance
  end

  def self.down
    drop_table :product_balances
  end
end
