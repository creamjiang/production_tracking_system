class CreateColdStoreAccounts < ActiveRecord::Migration
  def self.up
    create_table :cold_store_accounts do |t|
      t.integer :product_id
      t.date :report_on
      t.integer :opening_balance, :default => 0
      t.integer :debit, :default => 0
      t.integer :credit, :default => 0
      t.integer :closing_balance, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :cold_store_accounts
  end
end
