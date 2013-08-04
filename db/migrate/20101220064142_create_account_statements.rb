class CreateAccountStatements < ActiveRecord::Migration
  def self.up
    create_table :account_statements do |t|
      t.integer :routing_id, :null => false
      t.integer :routing_process_id, :null => false
      t.integer :routing_procedure_id, :null => false
      t.integer :product_id, :null => false
      t.string :generic_name, :null => false, :limit => 45
      t.integer :opening_balance, :default => 0
      t.integer :quantity_in, :default => 0
      t.integer :quantity_out, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :account_statements
  end
end
