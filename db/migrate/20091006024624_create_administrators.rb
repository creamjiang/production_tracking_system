class CreateAdministrators < ActiveRecord::Migration
  def self.up
    create_table :administrators do |t|
      t.string :name, :limit => 100
      t.string :login, :limit => 45
      t.string :hashed_password
      t.string :salt
      t.text :remark

      t.timestamps
    end
  end

  def self.down
    drop_table :administrators
  end
end
