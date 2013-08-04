class CreateBinStatuses < ActiveRecord::Migration
  def self.up
    create_table :bin_statuses do |t|
      t.string :name, :limit => 45
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :bin_statuses
  end
end
