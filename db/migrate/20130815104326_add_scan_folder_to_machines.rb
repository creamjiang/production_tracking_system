class AddScanFolderToMachines < ActiveRecord::Migration
  def self.up
    add_column :machines, :scan_folder, :string
  end

  def self.down
    remove_column :machines, :scan_folder
  end
end
