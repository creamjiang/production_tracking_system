class AddAliasToMachineDownReasons < ActiveRecord::Migration
  def self.up
    add_column :machine_down_reasons, :alias, :string
    add_column :machine_down_reasons, :routing_process_id, :integer, :default => 1
  end

  def self.down
    remove_column :machine_down_reasons, :routing_process_id
    remove_column :machine_down_reasons, :alias
  end
end
