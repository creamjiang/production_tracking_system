class BinStatus < ActiveRecord::Base
  self.record_timestamps = false
  has_many :bins
  validates_presence_of :name
  validates_uniqueness_of :name
  
  attr_protected :id, :name
  
  AVAILABLE = 1
  USED = 2
  SCRAP = 3
  FULL = 4
  INITIALIZE = 5
  
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
