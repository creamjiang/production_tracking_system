class AddDisabledToPrmsExports < ActiveRecord::Migration
  def self.up
    add_column :prms_exports, :disabled, :boolean, :default => false
    add_index :prms_exports, :disabled
  end

  def self.down
    remove_index :prms_exports, :disabled
    remove_column :prms_exports, :disabled
  end
end
