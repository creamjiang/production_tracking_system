class AddRunningDateToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :running_date, :date
  end

  def self.down
    remove_column :settings, :running_date
  end
end
