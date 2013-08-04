class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :employee_number, :limit => 45
      t.string :name, :limit => 100
      t.integer :department_id
      t.string :hashed_password
      t.string :salt, :limit => 20
      t.text :remark

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
