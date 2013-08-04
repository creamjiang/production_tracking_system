class AddGroupIdToAdministrator < ActiveRecord::Migration
  def self.up
    add_column :administrators, :group_id, :integer
  end

  def self.down
    remove_column :administrators, :group_id, :integer
  end
end
