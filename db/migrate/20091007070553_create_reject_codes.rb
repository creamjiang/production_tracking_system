class CreateRejectCodes < ActiveRecord::Migration
  def self.up
    create_table :reject_codes do |t|
      t.string :code, :limit => 45
      t.text :description
      t.integer :routing_process_id

      t.timestamps
    end
  end

  def self.down
    drop_table :reject_codes
  end
end
