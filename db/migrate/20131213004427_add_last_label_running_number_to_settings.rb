class AddLastLabelRunningNumberToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :last_label_running_number, :integer, :default => 0
  end

  def self.down
    remove_column :settings, :last_label_running_number
  end
end
