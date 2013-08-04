class CreateLoginRecords < ActiveRecord::Migration
  def self.up
    create_table :login_records do |t|
      t.integer :employee_id
      t.integer :machine_id
      t.boolean :logout, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :login_records
  end
end
