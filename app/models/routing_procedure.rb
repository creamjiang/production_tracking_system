class RoutingProcedure < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :routing_process
  belongs_to :routing
  has_many :working_states
  has_many :procedure_transactions
  has_many :machine_downtimes
  has_many :procedure_machines, :dependent => :destroy
  has_many :machines, :through => :procedure_machines
  has_many :transaction_summaries
  has_many :procedure_admins
  has_many :administrators, :through => :procedure_admins
  has_many :procedure_processes
  has_many :routing_processes, :through => :procedure_processes
  has_many :attached_products
  has_many :products, :through => :attached_products
  has_many :account_statements
  has_many :export_items
  has_many :product_balances
  has_many :routine_products
  
  before_create :change_create_timezone
  before_update :change_update_timezone
    
  attr_accessible :routing_process_id, :routing_id, :position
  attr_accessor :quantity 
  #validates_uniqueness_of :routing_process_id

  def self.options
    result = all(:order => "routing_id, routing_process_id", :joins => [:routing, :routing_process])
    dummy = new
    dummy.id = 0
    result.insert(0, dummy)
  end

  def fullname
    routing.name + "-" + routing_process.name rescue "Unassigned"
  end

  def collect_procedure_processes
    result = []
    procedure_processes.all.each do |p|
      result << p.routing_process
    end
    result
  end
  
  def get_all_machines_products
    result = []
    machines.each do |m|
      m.products.each {|p| 
        result << p  if ColdStore.product_quantity(p.id) > 0 
        }
    end
    result
  end

  def verify_for_destroy
   deleted = false
  
      if procedure_transactions.size.zero?
        if machine_downtimes.size.zero?
          destroy
          deleted = true
        end
      end unless working_state
       
    
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
