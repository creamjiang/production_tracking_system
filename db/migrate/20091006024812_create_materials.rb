class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
      t.string :raw_code, :limit => 45
      t.string :name, :limit => 45
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :materials
  end
end
