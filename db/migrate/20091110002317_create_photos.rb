class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.references :reject_code
      t.timestamps
    end
    add_index :photos, :reject_code_id

  end

  def self.down
    drop_table :photos
  end
end
