class AddFixedToMachineDowntimes < ActiveRecord::Migration
  def self.up
    add_column :machine_downtimes, :fixed, :boolean, :default => true
  end

  def self.down
    remove_column :machine_downtimes, :fixed
  end
end
