class AddIndexToTransactionSummaries < ActiveRecord::Migration
  def self.up
  	add_index :transation_summaries, [:product_id, :machine_id, :processing_date]
  end

  def self.down
  	remove_index :transation_summaries, [:product_id, :machine_id, :processing_date]
  end
end
