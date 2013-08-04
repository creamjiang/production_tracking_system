class AddMacAdressToMachine < ActiveRecord::Migration
  def self.up
    add_column :machines, :mac_address, :string
  end

  def self.down
    remove_column :machines, :mac_address
  end
end
