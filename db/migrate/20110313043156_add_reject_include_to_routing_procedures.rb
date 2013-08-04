class AddRejectIncludeToRoutingProcedures < ActiveRecord::Migration
  def self.up
    add_column :routing_procedures, :reject_include, :boolean, :default => false
    add_index :routing_procedures, :reject_include
  end

  def self.down
    remove_index :routing_procedures, :reject_include
    remove_column :routing_procedures, :reject_include
  end
end
