class RoutingProcess < ActiveRecord::Base
  self.record_timestamps = false
  has_many :routing_procedures
  has_many :reject_codes, :order => "alias"
  has_many :procedure_transactions
  has_many :machine_downtimes
  has_many :routings, :through => :routing_procedures 
  has_many :transaction_summaries
  has_many :machine_down_reasons
  has_many :procedure_products
  has_many :products, :through => :procedure_products
  has_many :daily_transactions
  has_many :procedure_processes
  has_many :attached_products
  has_many :account_statements

  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
    
  attr_accessible :name, :description
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def verify_for_destroy
   deleted = false
      if routing_procedures.size.zero?
        if reject_codes.size.zero?
          if procedure_transactions.size.zero?
            if machine_downtimes.size.zero?
              destroy
              deleted = true
            end
          end
        end
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
