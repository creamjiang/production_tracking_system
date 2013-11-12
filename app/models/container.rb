class Container < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :product, :counter_cache => true
  belongs_to :bin_type
  has_many :procedure_transactions
  has_many :machine_downtimes
    
  named_scope :contained_product, lambda {|product_id| {:conditions => ["product_id = ?", product_id]}}
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  
  def verify_for_destroy
   deleted = false
      
    if procedure_transactions.size.zero?
      if machine_downtimes.size.zero?
        destroy
        deleted = true
      end
    end
    
    deleted
  end
  
  def self.container(product_id)
    containers = Container.contained_product(product_id)
    bin_types = []
    containers.each {|c| bin_types << c.bin_type}
    bin_types.uniq!
    bin_types
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
