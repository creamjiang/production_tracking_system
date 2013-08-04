class Group < ActiveRecord::Base
  self.record_timestamps = false
  attr_accessible :name, :alias, :description, :builtin, :position
  has_many :administrators
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  ICT_ADMIN = 1
  APPLICATION_ADMIN = 2
  REPORT_VIEWER = 3
  MATERIAL_INPUT = 4
  PRMS_ADMIN = 5
  
  BUILTIN = [
  ["ICT Administrator", ICT_ADMIN],
  ["Application Administrator", APPLICATION_ADMIN],
  ["Material Input", MATERIAL_INPUT],
  ["Report Viewer", REPORT_VIEWER],
  ["PRMS Admin", PRMS_ADMIN]
  ].freeze
  
  def verify_for_destroy
   deleted = false
    
     if administrators.size.zero?
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
