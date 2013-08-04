class CreateColdStores < ActiveRecord::Migration
  def self.up
    create_table :cold_stores do |t|
      t.integer :procedure_transaction_id, :default => 0
      t.date :on_hold_date
      t.date :converted_date
      t.smallint :status, :default => 0
      t.timestamps
    end
  end
  
  def self.down
    drop_table :cold_stores
  end
end
