class Category < ActiveRecord::Base
  self.record_timestamps = false
  has_many :products
  
  attr_accessible :name, :description
  validates_presence_of :name
  validates_uniqueness_of :name
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  def verify_for_destroy
   deleted = false
      if products.size.zero?
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
