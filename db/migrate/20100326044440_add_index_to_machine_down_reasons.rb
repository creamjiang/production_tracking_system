class AddIndexToMachineDownReasons < ActiveRecord::Migration
  def self.up
    say_with_time("adding index ...") do
      add_index :machine_down_reasons, :routing_process_id
    end
    
    say_with_time("copying code to alias") do
      MachineDownReason.all.each do |m|
        m.alias = m.code
        m.save!
      end
    end
    
  end

  def self.down
  end
end
