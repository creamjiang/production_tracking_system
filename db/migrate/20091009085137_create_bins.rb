class CreateBins < ActiveRecord::Migration
  def self.up
    create_table :bins do |t|
      t.string :bin_number, :limit => 45
      t.integer :bin_type_id
      t.integer :bin_status_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :bins
  end
end
