class ProcedureMachine < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :routing_procedure
  belongs_to :machine
  belongs_to :routing
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  private
  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end
  
  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end
  
  
end
