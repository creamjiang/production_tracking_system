class CreateBinTypes < ActiveRecord::Migration
  def self.up
    create_table :bin_types do |t|
      t.string :name, :limit => 45
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :bin_types
  end
end
