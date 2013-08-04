class CreateAttachedProducts < ActiveRecord::Migration
  def self.up
    create_table :attached_products do |t|
      t.integer :machine_id
      t.integer :product_id
      t.boolean :visible, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :attached_products
  end
end
