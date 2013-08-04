class AddDurationToEfficiencySchedules < ActiveRecord::Migration
  def self.up
    add_column :efficiency_schedules, :duration, :integer, :default => 0
  end

  def self.down
    remove_column :efficiency_schedules, :duration
  end
end
