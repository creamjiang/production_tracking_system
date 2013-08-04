class Material < ActiveRecord::Base
  self.record_timestamps = false
  attr_accessible :raw_code, :name, :description
  has_many :material_inputs
  has_many :machines, :through => :material_inputs
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  validates_presence_of :name, :raw_code
  validates_uniqueness_of :name, :raw_code
  
  
#  def verify_for_destroy
#   deleted = false
#      if bins.size.zero?
#        if containers.size.zero?
#          if procedure_transactions.size.zero?
#            if machine_downtimes.size.zero?
#              destroy
#              deleted = true
#            end
#          end
#        end
#      end
#    
#    deleted
#  end

  private
  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end
  
  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end
  
end
