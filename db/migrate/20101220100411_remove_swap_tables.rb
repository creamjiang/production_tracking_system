class RemoveSwapTables < ActiveRecord::Migration
  def self.up
    drop_table(:swap_groups)
    drop_table(:swap_group_items)
  end

  def self.down
  end
end
