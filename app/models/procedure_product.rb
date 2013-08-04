class ProcedureProduct < ActiveRecord::Base
  self.record_timestamps = false
  #belongs_to :product
  #belongs_to :routing_process
  
  attr_accessible :generic_name, :description, #:routing_process_id, :product_id

  
  validates_presence_of(:generic_name)
  validates_uniqueness_of(:generic_name)
  
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
