class ProcedureTransaction < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :product
  belongs_to :employee
  belongs_to :routing
  belongs_to :routing_process
  belongs_to :routing_procedure
  belongs_to :machine
  belongs_to :bin
  belongs_to :bin_type
  belongs_to :container
  belongs_to :reject_code
  has_many :flush_accounts
  has_many :export_items, :through => :flush_accounts
  has_one :cold_store
  
  #attr_accessible :quantity, :shift_id, :transaction_date, :product_id, :employee_id, :routing_id, :routing_process_id, :routing_procedure_id, :machine_id, :bin_id, :bin_type_id, :container_id, :reject_code_id, :status
  attr_protected(:id)
  before_create :change_create_timezone
  before_create :update_generic_name
  before_update :change_update_timezone
  
  named_scope :success , lambda {|search_date| {:conditions => ["status = ? and transaction_date = ?", ProcedureTransaction::GOOD, search_date]}}
  named_scope :reject , lambda {|search_date| {:conditions => ["status = ? and transaction_date = ?", ProcedureTransaction::REJECT, search_date]}}
  named_scope :on_hold , lambda {|search_date| {:conditions => ["status = ? and transaction_date = ?", ProcedureTransaction::ONHOLD, search_date]}}
  
  UNKNOWN = 0
  GOOD = 1
  REJECT = 2
  ONHOLD = 3
  GOOD2 = 4
  REJECT2 = 5
  
  PROCESS_STATUSES = [
  ["Good", GOOD],
  ["Reject", REJECT],
  ["On Hold", ONHOLD]
  ].freeze
  
  REPROCESS_STATUSES = [
  ["Good", GOOD2],
  ["Reject", REJECT2]
  ].freeze
  
  OPTION_STATUSES = [
  ["On Hold", ONHOLD],
  ["Unknown", UNKNOWN]
  ].freeze
  
  def generate_cold_store(input_quantity, input_date, input_status, input_product_id)
    found = ColdStore.first(:conditions => ["on_hold_date = ? and status = ? and product_id = ?", input_date, input_status, input_product_id], :lock => true)
    
    if found
      found.quantity += input_quantity
      found.save(false)
    else
      create_cold_store(:quantity => input_quantity, :on_hold_date => input_date, :status => input_status, :product_id => input_product_id)
    end
  end
  
  def self.generate_report(query_date, shift_id, machine_id)
    collected_data = self.find_by_sql("select a.reject_code_id, a.generic_name, b.side, b.description, mid(c.code,1,4) as code, mid(c.description,1,30) as reject_description, count(*) as quantity from procedure_transactions as a, products as b, reject_codes as c where (a.product_id = b.id) and (a.reject_code_id = c.id) and a.transaction_date = '" + query_date + "' and a.machine_id = " + machine_id.to_s + " and a.shift_id = " + shift_id.to_s + " and status = 2 group by a.routing_process_id, b.part_number, b.side, a.transaction_date, c.description order by quantity DESC")
    
    result = []
    collected_data.each do |c|
      found = false
      
      result.each do |d|
        if d.reject_code_id == c.reject_code_id
          found = true
          case c.side
            when "Left"
              d.left_quantity += c.quantity
            when "Right"
              d.right_quantity += c.quantity
            when "Common"
              d.quantity += c.quantity
          end
        end
        
      end
       
      unless found
        nr = DailyTransaction.new
        nr.reject_code_id = c.reject_code_id
        nr.reject_code = c.code
        nr.description = c.reject_description
        nr.left_quantity = 0
        nr.right_quantity = 0
        nr.quantity = 0
        
        case c.side
          when "Left"
            nr.left_quantity = c.quantity
          when "Right"
            nr.right_quantity = c.quantity
          when "Common"
            nr.quantity = c.quantity
        end
        
        result << nr
      end
    end
    result
  end
  
  def status_name
    case status
      when GOOD
        return "Good"
      when REJECT
        return "Reject"
      when ONHOLD
        return "On Hold"
      when GOOD2
        return "Good2"
      when REJECT2
        return "Reject2"
      end
        
  end
  
  private
  
  def change_create_timezone
    self.created_at = Time.now + 8.hours if created_at.blank?
    self.updated_at = Time.now + 8.hours
  end

  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end

  
  def update_generic_name
    p = product
    if p
      self.generic_name = p.generic_name
    else
      self.generic_name = "Not found"
    end
  end
  

end
