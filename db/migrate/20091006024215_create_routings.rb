class CreateRoutings < ActiveRecord::Migration
  def self.up
    create_table :routings do |t|
      t.string :name, :limit => 45
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :routings
  end
end
