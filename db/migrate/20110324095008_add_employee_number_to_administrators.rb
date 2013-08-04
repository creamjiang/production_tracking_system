class AddEmployeeNumberToAdministrators < ActiveRecord::Migration
  def self.up
    add_column :administrators, :employee_number, :string, :null => false
  end

  def self.down
    remove_column :administrators, :employee_number
  end
end
