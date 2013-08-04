class AddConfirmedReasonTimeToMachineDowntimes < ActiveRecord::Migration
  def self.up
    add_column :machine_downtimes, :confirmed_reason_time, :datetime
  end

  def self.down
    remove_column :machine_downtimes, :confirmed_reason_time
  end
end
