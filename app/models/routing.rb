class Routing < ActiveRecord::Base
  self.record_timestamps = false
  has_many :routing_procedures
  has_many :procedure_transactions
  has_many :machine_downtimes
  has_many :routing_processes, :through => :routing_procedures
  has_many :procedure_machines
  has_many :machines, :through => :procedure_machines
  has_many :transaction_summaries
  has_many :daily_transactions
  has_many :attached_products
  has_many :products, :through => :attached_products
  has_many :account_statements

  
  before_create :change_create_timezone
  before_update :change_update_timezone
    
  attr_accessible :name, :description
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def exception_processes
    result = []
    RoutingProcess.all.each do |r|
      unless routing_processes.include?(r)
        result << r
      end
    end
    result
  end
  
  def verify_for_destroy
   deleted = false
 
        if routing_procedures.size.zero?
          if procedure_transactions.size.zero?
            if machine_downtimes.size.zero?
              destroy
              deleted = true
            end
          end
        end

    deleted
  end
  
  def collect_processes(routing_procedure)
    procedures = routing_procedure.procedure_processes.all(:conditions => ["routing_process_id != ?", routing_procedure.routing_process_id])
    processes = []
    procedures.each {|c| processes << c.routing_process }
    processes.uniq
  end
  
  
  def enable_process
    duplicate = 0
    machines.each do |c|
      if ProcedureMachine.first(:conditions => ["routing_id != ? and machine_id = ? and suspend = 0", id, c.id])
        duplicate += 1
      end
    end
    
    if duplicate == 0
      procedure_machines.each {|d| 
        d.suspend = false
        d.save(false)
      }
      self.suspend = false
      save(false)
      result = 1
    else
      result = -1
    end
    result
  end
  
  def disable_process
    procedure_machines.each {|d| 
        d.suspend = true
        d.save(false)
      }
      self.suspend = true
      save(false)
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
