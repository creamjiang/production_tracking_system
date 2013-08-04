class AddShiftIdToMachineDowntimes < ActiveRecord::Migration
  def self.up
    add_column :machine_downtimes, :shift_id, :integer, :default => 0
  end

  def self.down
    remove_column :machine_downtimes, :shift_id
  end
end
