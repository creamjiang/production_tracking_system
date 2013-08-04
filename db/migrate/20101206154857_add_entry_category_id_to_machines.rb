class AddEntryCategoryIdToMachines < ActiveRecord::Migration
  def self.up
    add_column :machines, :entry_category_id, :integer, :default => 0
    add_index  :machines, :entry_category_id
  end

  def self.down
    remove_index  :machines, :entry_category_id
    remove_column :machines, :entry_category_id
  end
end
