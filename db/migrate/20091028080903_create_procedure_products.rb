class CreateProcedureProducts < ActiveRecord::Migration
  def self.up
    create_table :procedure_products do |t|
      t.string :generic_name, :limit => 45
      t.integer :routing_process_id
      t.integer :product_id
      t.text :description
      t.timestamps
    end
  end
  
  def self.down
    drop_table :procedure_products
  end
end
