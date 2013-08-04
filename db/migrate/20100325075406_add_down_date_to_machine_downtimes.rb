class AddDownDateToMachineDowntimes < ActiveRecord::Migration
  def self.up
    add_column :machine_downtimes, :down_date, :date
  end

  def self.down
    remove_column :machine_downtimes, :down_date
  end
end
