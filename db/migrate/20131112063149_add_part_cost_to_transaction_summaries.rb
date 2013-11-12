class AddPartCostToTransactionSummaries < ActiveRecord::Migration
  def self.up
    add_column :transaction_summaries, :part_cost, :decimal, :precision => 6, :scale => 2
  end

  def self.down
    remove_column :transaction_summaries, :part_cost
  end
end
