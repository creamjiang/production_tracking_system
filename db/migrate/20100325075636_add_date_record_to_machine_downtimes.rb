class AddDateRecordToMachineDowntimes < ActiveRecord::Migration
  def self.up
    say_with_time("update downtime date...") do
      MachineDowntime.all.each do |m|
        m.down_date = m.created_at.strftime("%Y-%m-%d")
        m.save!
      end
    end
  end

  def self.down
  end
end
