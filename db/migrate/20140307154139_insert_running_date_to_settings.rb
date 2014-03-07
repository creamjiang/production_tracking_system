class InsertRunningDateToSettings < ActiveRecord::Migration
  def self.up
  	setting = Setting.first
  	setting.running_date = Date.today
  	setting.save
  end

  def self.down
  end
end
