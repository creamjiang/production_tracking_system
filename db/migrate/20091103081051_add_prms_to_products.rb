class AddPrmsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :technology, :string, :limit => 45
    add_column :products, :processed_parts, :string, :limit => 45
    add_column :products, :processed_part_description, :string, :limit => 45
    add_column :products, :prms_description, :string, :limit => 45
    add_column :products, :prms_description_1, :string, :limit => 45
  end

  def self.down
    remove_column :products, :prms_description_1
    remove_column :products, :prms_description
    remove_column :products, :processed_part_description
    remove_column :products, :processed_parts
    remove_column :products, :technology
  end
end
