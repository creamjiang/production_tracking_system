class Department < ActiveRecord::Base
  self.record_timestamps = false
  has_many :employees
  attr_accessible :name, :description, :position, :alias
  validates_presence_of :name
  validates_uniqueness_of :name
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  REVIEWER = 4
  OPERATOR = 3
  TECHNICIAN = 2
  SUPERVISOR = 1
  
  BUILTIN = [
  ["Supervisor", SUPERVISOR],
  ["Technician",  TECHNICIAN],
  ["Operator", OPERATOR],
  ["Reviewer", REVIEWER]
  ].freeze
  
  
  def verify_for_destroy
   deleted = false
    
     if employees.size.zero?
         destroy
         deleted = true
     end unless builtin
        
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
