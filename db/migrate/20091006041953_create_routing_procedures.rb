class CreateRoutingProcedures < ActiveRecord::Migration
  def self.up
    create_table :routing_procedures do |t|
      t.integer :routing_id
      t.integer :routing_process_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :routing_procedures
  end
end
