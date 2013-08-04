class CreateDestinations < ActiveRecord::Migration
  def self.up
    create_table :destinations do |t|
      t.integer :warehouse_id, :null => false
      t.string :name, :limit => 45
      t.string :location, :limit => 45
      t.string :remark

      t.timestamps
    end
    add_index :destinations, :warehouse_id
  end

  def self.down
    drop_table :destinations
  end
end
