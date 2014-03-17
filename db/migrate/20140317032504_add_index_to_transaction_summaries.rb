class AddIndexToTransactionSummaries < ActiveRecord::Migration
  def self.up
  	add_index :transaction_summaries, [:product_id, :machine_id, :processing_date], :order => { :processing_date => :asc, :shift_id => :asc }
  end

  def self.down
  	remove_index :transaction_summaries, [:product_id, :machine_id, :processing_date]
  end
end
