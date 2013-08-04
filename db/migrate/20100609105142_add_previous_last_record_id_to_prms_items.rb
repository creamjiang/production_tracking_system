class AddPreviousLastRecordIdToPrmsItems < ActiveRecord::Migration
  def self.up
    add_column :prms_items, :last_record_id, :integer
    add_index :prms_items, :last_record_id
  end

  def self.down
    remove_column :prms_items, :last_record_id
  end
end
