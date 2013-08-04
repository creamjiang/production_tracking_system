class AddFixedTimeToMachineDowntimes < ActiveRecord::Migration
  def self.up
    add_column :machine_downtimes, :fixed_time, :datetime
    
    
    MachineDowntime.all.each do |m|
      m.fixed_time = m.updated_at + 8.hours
      m.save!
    end
  end

  def self.down
    remove_column :machine_downtimes, :fixed_time
  end
end
