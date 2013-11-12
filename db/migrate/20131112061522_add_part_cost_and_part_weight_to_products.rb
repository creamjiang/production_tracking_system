class AddPartCostAndPartWeightToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :part_cost, :decimal, :precision => 6, :scale => 2
    add_column :products, :part_weight, :decimal, :precision => 6, :scale => 2
  end

  def self.down
    remove_column :products, :part_weight
    remove_column :products, :part_cost
  end
end
