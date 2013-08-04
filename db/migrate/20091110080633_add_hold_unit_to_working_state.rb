class AddHoldUnitToWorkingState < ActiveRecord::Migration
  def self.up
    add_column :working_states, :hold_unit, :integer, :default => 0
  end

  def self.down
    remove_column :working_states, :hold_unit
  end
end
