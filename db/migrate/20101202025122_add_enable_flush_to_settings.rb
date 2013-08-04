class AddEnableFlushToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :enable_flush, :boolean, :default => false
  end

  def self.down
    remove_column :settings, :enable_flush
  end
end
