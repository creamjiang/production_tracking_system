class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.boolean :register_bin_with_scanner, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
