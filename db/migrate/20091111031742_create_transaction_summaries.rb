class CreateTransactionSummaries < ActiveRecord::Migration
  def self.up
    create_table :transaction_summaries do |t|
      t.integer :employee_id, :default => 0
      t.integer :machine_id, :default => 0
      t.integer :product_id, :default => 0
      t.integer :routing_procedure_id, :default => 0
      t.integer :routing_process_id, :default => 0
      t.integer :routing_id, :default => 0
      t.integer :shift_id, :default => 0
      t.integer :good_unit, :default => 0
      t.integer :reject_unit, :default => 0
      t.integer :hold_unit, :default => 0
      t.date :processing_date
      t.timestamps
    end
    
    add_index :transaction_summaries, :employee_id
    add_index :transaction_summaries, :machine_id
    add_index :transaction_summaries, :product_id
    add_index :transaction_summaries, :shift_id
    add_index :transaction_summaries, :processing_date
  end
  
  def self.down
    drop_table :transaction_summaries
  end
end
