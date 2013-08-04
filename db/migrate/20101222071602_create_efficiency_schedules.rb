class CreateEfficiencySchedules < ActiveRecord::Migration
  def self.up
    create_table :efficiency_schedules do |t|
      t.date :schedule_date, :null => false
      t.integer :product_id, :null => false
      t.string :part_name, :null => false
      t.string :shift_type, :null => false
      t.string :shift, :null => false
      t.time :start_time, :null => false
      t.time :end_time, :null => false
      t.integer :operators_present, :null => false
      t.integer :expected_output, :null => false
      t.string :operation_status, :null => false
      t.integer :machine_down_reason_id, :default => 0
      t.string :down_reason_code, :default => ""

      t.timestamps
    end
    add_index :efficiency_schedules, :schedule_date
    add_index :efficiency_schedules, :product_id
    add_index :efficiency_schedules, :start_time
    add_index :efficiency_schedules, :end_time
  end

  def self.down
    drop_table :efficiency_schedules
  end
end
