class CreateBinClearingRecords < ActiveRecord::Migration
  def self.up
    create_table :bin_clearing_records do |t|
      t.integer :employee_id
      t.integer :bin_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bin_clearing_records
  end
end
