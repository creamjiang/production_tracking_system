class TransactionSummary < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :employee
  belongs_to :product
  belongs_to :shift
  belongs_to :machine
  belongs_to :routing
  belongs_to :routing_process
  belongs_to :routing_procedure
  
  attr_accessible :employee_id, :machine_id, :product_id, :routing_procedure_id, :routing_process_id, :routing_id, :shift_id, :good_unit, :reject_unit, :hold_unit, :processing_date

  before_create :change_create_timezone
  before_update :change_update_timezone

  def shift_name
    current_shift = Shift.find(shift_id) rescue nil
    current_shift ? current_shift.name : "Unknown"
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
