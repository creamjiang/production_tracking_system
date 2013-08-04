class CreateShiftItems < ActiveRecord::Migration
  def self.up
    create_table :shift_items do |t|
      t.integer :machine_id
      t.integer :shift_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :shift_items
  end
end
