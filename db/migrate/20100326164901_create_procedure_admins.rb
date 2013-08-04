class CreateProcedureAdmins < ActiveRecord::Migration
  def self.up
    create_table :procedure_admins do |t|
      t.integer :administrator_id
      t.integer :routing_procedure_id

      t.timestamps
    end
    
    add_index :procedure_admins, :administrator_id
    add_index :procedure_admins, :routing_procedure_id
  end

  def self.down
    drop_table :procedure_admins
  end
end
