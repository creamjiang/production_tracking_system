class RoutineProduct < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :routing_procedure
  belongs_to :product
  belongs_to :bin_type
  belongs_to :warehouse

  before_create :change_create_timezone
  before_update :change_update_timezone

  def include_reject_status
    case reject_include
    when true
      "<em style='color:red'>Yes</em>"
    when false
      "<em style='color:green'>No</em>"
    end
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
