class CreateProcedureTransactions < ActiveRecord::Migration
  def self.up
    create_table :procedure_transactions do |t|
      t.integer :routing_procedure_id
      t.integer :employee_id
      t.integer :product_id
      t.integer :machine_id
      t.integer :routing_id
      t.integer :routing_process_id
      t.integer :bin_id
      t.integer :bin_type_id
      t.integer :container_id
      t.smallint :status, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :procedure_transactions
  end
end
