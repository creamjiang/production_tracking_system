class AddContainersCountToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :containers_count, :integer, :default => 0
    
    Product.reset_column_information
    Product.find(:all).each do |p|
    Product.update_counters p.id, :containers_count => p.containers.length
  end

  end

  def self.down
    remove_column :products, :containers_count
  end
end
