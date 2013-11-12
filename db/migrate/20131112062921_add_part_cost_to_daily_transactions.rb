class AddPartCostToDailyTransactions < ActiveRecord::Migration
  def self.up
    add_column :daily_transactions, :part_cost, :decimal, :precision => 6, :scale => 2
  end

  def self.down
    remove_column :daily_transactions, :part_cost
  end
end
