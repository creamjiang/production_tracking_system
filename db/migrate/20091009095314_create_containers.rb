class CreateContainers < ActiveRecord::Migration
  def self.up
    create_table :containers do |t|
      t.integer :product_id
      t.integer :bin_id
      t.integer :maximum_load, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :containers
  end
end
