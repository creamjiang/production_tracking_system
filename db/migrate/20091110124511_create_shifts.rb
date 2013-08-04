class CreateShifts < ActiveRecord::Migration
  def self.up
    create_table :shifts do |t|
      t.string :name, :limit => 45
      t.time :time_start
      t.time :time_end
      t.text :description
      t.timestamps
    end
  end
  
  def self.down
    drop_table :shifts
  end
end
