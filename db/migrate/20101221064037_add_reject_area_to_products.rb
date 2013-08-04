class AddRejectAreaToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :reject_area_category, :integer, :limit => 1, :default => 8
    add_column :daily_transactions, :reject_area, :string, :limit => 2, :default => "00"
    add_column :procedure_transactions, :reject_area, :string, :limit => 2, :default => "00"

    add_index :procedure_transactions, :reject_area
    add_index :daily_transactions, :reject_area
    add_index :products, :reject_area_category
  end

  def self.down
    remove_index :procedure_transactions, :reject_area
    remove_column :procedure_transactions, :reject_area
    remove_index :daily_transactions, :reject_area
    remove_column :daily_transactions, :reject_area
    remove_index :products, :reject_area_category
    remove_column :products, :reject_area_category
  end
end
