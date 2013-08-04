class MachineDownReason < ActiveRecord::Base
  self.record_timestamps = false
  has_many :machine_downtimes
  has_many :efficiency_schedules
  belongs_to :routing_process
  
  attr_accessible :description, :code, :alias, :routing_process_id
  validates_uniqueness_of :code
  validates_presence_of :description, :code, :alias
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  def verify_for_destroy
   deleted = false
      if machine_downtimes.size.zero?
         destroy
         deleted = true
      end
    
    deleted
  end
  
  private
  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end
  
  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end
  
end
