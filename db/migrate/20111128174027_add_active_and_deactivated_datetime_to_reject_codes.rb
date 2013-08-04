class AddActiveAndDeactivatedDatetimeToRejectCodes < ActiveRecord::Migration
  def self.up
    add_column :reject_codes, :active, :boolean, :default => true
    add_column :reject_codes, :deactived_time, :datetime
  end

  def self.down
    remove_column :reject_codes, :active
    remove_column :reject_codes, :deactived_time
  end
end
