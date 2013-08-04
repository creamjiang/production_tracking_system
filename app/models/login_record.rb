class LoginRecord < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :employee
  belongs_to :machine
  
  attr_accessible :employee_id, :machine_id
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  named_scope :active, :conditions => {:logout => false}
  
  INVALID_LOGIN = 1
  INVALID_PASSWORD = 2
  LOGIN_FREEZED = 3
  INVALID_MACHINE = 4
  
  private
  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end
  
  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end
end
