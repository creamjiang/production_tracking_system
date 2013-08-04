class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :part_number, :limit => 45
      t.text :description
      t.integer :category_id
      t.string :customer
      t.string :part_name
      t.string :side

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
