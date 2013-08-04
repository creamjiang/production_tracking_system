class CreateOperators < ActiveRecord::Migration
  def self.up
    create_table :operators do |t|
      t.integer :machine_id
      t.integer :employee_id

      t.timestamps
    end
  end

  def self.down
    drop_table :operators
  end
end
