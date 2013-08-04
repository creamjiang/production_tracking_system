class AddQuantityToFlushAccounts < ActiveRecord::Migration
  def self.up
    add_column :flush_accounts, :quantity, :integer, :null => false
  end

  def self.down
    remove_column :flush_accounts, :quantity
  end
end
