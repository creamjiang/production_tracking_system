class AddSuspendToRoutings < ActiveRecord::Migration
  def self.up
    add_column :routings, :suspend, :boolean, :default => false
  end

  def self.down
    remove_column :routings, :suspend
  end
end
