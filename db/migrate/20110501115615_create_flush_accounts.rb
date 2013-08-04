class CreateFlushAccounts < ActiveRecord::Migration
  def self.up
    create_table :flush_accounts do |t|
      t.integer :procedure_transaction_id, :null => false
      t.integer :export_item_id, :null => false

      t.timestamps
    end
    add_index :flush_accounts, :procedure_transaction_id
    add_index :flush_accounts, :export_item_id
  end

  def self.down
    drop_table :flush_accounts
  end
end
