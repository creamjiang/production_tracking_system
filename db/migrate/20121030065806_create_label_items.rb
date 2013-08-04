class CreateLabelItems < ActiveRecord::Migration
  def self.up
    create_table :label_items do |t|
      t.integer :working_state_id, :null => false
      t.integer :procedure_transaction_id, :null => false
      t.integer :box_label_id, :default => 0

      t.timestamps
    end
    add_index :label_items, :working_state_id
    add_index :label_items, :procedure_transaction_id
    add_index :label_items, :box_label_id
  end

  def self.down
    drop_table :label_items
  end
end
