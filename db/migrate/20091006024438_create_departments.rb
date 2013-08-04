class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.string :name, :limit => 45
      t.string :alias, :limit => 45
      t.text :description
      t.boolean :builtin, :default => false
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :departments
  end
end
