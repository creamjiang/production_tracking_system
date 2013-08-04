class RejectCode < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :routing_process
  has_many :procedure_transactions
  has_many :photos
  
  validates_presence_of :code
  validates_uniqueness_of :code, :scope => :routing_process_id

  
  before_create :change_create_timezone
  before_update :change_update_timezone, :check_deactivated_time
  
  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
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
  
  def check_deactivated_time
    if active == false
      self.deactivated_time = Time.now + 8.hours if active_changed?
    end
  end
  
end
