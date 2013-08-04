class AddPostedToPrmsExports < ActiveRecord::Migration
  def self.up
    add_column :prms_exports, :posted, :boolean, :default => false
    add_index :prms_exports, :posted
  end

  def self.down
    remove_index :prms_exports, :posted
    remove_column :prms_exports, :posted
  end
end
