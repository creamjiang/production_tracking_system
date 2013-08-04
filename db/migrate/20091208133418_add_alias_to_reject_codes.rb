class AddAliasToRejectCodes < ActiveRecord::Migration
  def self.up
    add_column :reject_codes, :alias, :string, :limit => 45
    add_column :machine_down_reasons, :code, :string, :limit => 45
  end

  def self.down
    remove_column :reject_codes, :alias
    remove_column :machine_down_reasons, :code
  end
end
