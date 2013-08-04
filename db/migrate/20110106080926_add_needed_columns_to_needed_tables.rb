class AddNeededColumnsToNeededTables < ActiveRecord::Migration
  def self.up
    add_column :bin_types, :maximum_load, :integer, :default => 0
    add_column :bin_types, :bin_barcode_format, :string, :default => "BARCODE_128"
    add_column :bin_types, :bin_barcode_text, :string
    add_column :bin_types, :product_barcode_format, :string, :default => "BARCODE_128"
    add_column :bin_types, :product_barcode_text, :string
    add_column :attached_products, :bin_type_id, :integer, :default => 0
    add_index  :attached_products, :bin_type_id
    rename_column(:working_states, :bin_id, :bin_type_id)
    rename_column(:working_states, :good_unit, :loaded_unit)
    remove_column(:working_states, :employee_id)
    remove_column(:working_states, :reject_unit)
    remove_column(:working_states, :hold_unit)
    add_index  :working_states, :bin_type_id
    add_column :working_states, :attached_product_id, :integer
    add_index  :working_states, :attached_product_id
    add_column :working_states, :maximum_load, :integer, :default => 0
  end

  def self.down
  end
end
