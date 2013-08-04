class CreateSecondPrmsExports < ActiveRecord::Migration
  def self.up
    create_table :prms_exports do |t|
      t.date :export_date, :null => false
      t.string :remark
      t.integer :administrator_id, :null => false

      t.timestamps
    end
    add_index :prms_exports, :administrator_id
    add_index :prms_exports, :export_date
  end

  def self.down
    remove_index :prms_exports, :administrator_id
    remove_index :prms_exports, :export_date
    drop_table :prms_exports
  end
end
