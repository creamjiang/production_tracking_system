class CreateBoxLabels < ActiveRecord::Migration
  def self.up
    create_table :box_labels do |t|
      t.string :code, :limit => 12
      t.integer :product_id, :null => false, :default => 0
      t.integer :machine_id, :null => false, :default => 0
      t.integer :quantity, :null => false, :default => 0
      t.integer :employee_id, :null => false, :default => 0
      t.datetime :boxed_date_time

      t.timestamps
    end
    add_index :box_labels, :product_id
    add_index :box_labels, :machine_id
    add_index :box_labels, :employee_id
    add_index :box_labels, :code
  end

  def self.down
    drop_table :box_labels
  end
end
