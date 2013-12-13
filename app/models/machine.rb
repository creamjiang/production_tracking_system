class Machine < ActiveRecord::Base
  self.record_timestamps = false
  has_many :operators
  has_many :employees, :through => :operators
  has_many :shift_items
  has_many :shifts, :through => :shift_items
  has_many :working_states
  has_many :procedure_transactions
  has_many :machine_downtimes
  has_many :login_records
  has_many :attached_products, :include => :product, :order => "products.part_name"
  has_many :products, :through => :attached_products, :order => "part_number"
  has_many :procedure_machines, :conditions => "suspend = 0"
  has_many :routing_procedures, :through => :procedure_machines
  has_many :input_machines
  has_many :material_inputs, :through => :input_machines
  has_many :transaction_summaries
  has_many :box_labels
  
  before_create :change_create_timezone
  before_update :change_update_timezone
    
  attr_accessible :machine_number, :asset_number, :description, :mac_address, :entry_category_id, :scan_folder
  validates_presence_of :machine_number, :asset_number, :mac_address
  validates_uniqueness_of :machine_number, :mac_address #, :asset_number
  #validates_uniqueness_of :scan_folder, :allow_blank => true, :allow_nil => true
  
  TOUCHSCREEN = 0
  DATA_ENTRY = 1
  BARCODE_MODE = 2
  
  def data_mode
    case entry_category_id
      when Machine::DATA_ENTRY
        "Data Entry"
      when Machine::TOUCHSCREEN
        "TouchScreen"
      when Machine::BARCODE_MODE
        "Barcode Mode"
    end
  end

  def is_data_entry?
    entry_category_id == Machine::DATA_ENTRY
  end

  def is_barcode_mode?
    entry_category_id == Machine::BARCODE_MODE
  end
  
#  def swapable_processes
#    routing_procedure.routing_process.swap_group.routing_processes rescue []
#  end

  def is_bin_type_set?
    checked = true
    attached_products.each do |a|
      checked = false unless a.bin_type
    end
    checked
  end
  
  def exception_shifts
    result = []
    Shift.all.each do |s|
      unless shifts.include?(s)
        result << s
      end
    end
    result
  end
  
  def exception_products(selected_products)
    result = []
    selected_products.each do |p|
      unless products.include?(p)
        result << p
      end
    end
    result
  end
  
  def exception_employees
    result = []
    Employee.all.each do |e|
      unless employees.include?(e)
        result << e
      end
    end
    result
  end
  
  def current_shift
    found = false 
    shift = []
    
    shifts.each do |c|
      if found == false
        running = c.time_start.hour.to_i
        stop_point = c.time_end.hour.to_i
        check_numbers = []
        stop_running = false
        
        until stop_running == true do
          if running == stop_point
            check_numbers << running
            stop_running = true
          else
            if running == 23
              check_numbers << running
              running = 0  
            else
              check_numbers << running
              running += 1
            end
          end
        end
        
        found = true if check_numbers.include?(Time.now.hour.to_i)
        shift << c if found
      end
    end
    
    shift[0]
  end
  
  def reject_report(from, to)
    procedure_transactions.all(:conditions => ["transaction_date IN (?) and reject_code_id > 0", from..to])
  end
  
  def waiting_for_down_reason?
    downtime = machine_downtimes.first(:conditions => "fixed = false")
    if downtime
      downtime.machine_down_reason_id > 0 ? false : true
    else
      return false
    end
  end
    
  def verify_for_destroy
   deleted = false
     
        if operators.size.zero?
          if procedure_transactions.size.zero?
            if machine_downtimes.size.zero?
              unless routing_procedure
                destroy
                deleted = true
              end
            end
          end
      end if working_states.size.zero?
    
    deleted
  end
  
  def find_or_generate_transaction_summary(input_quantity, product_id, employee_id, routing_procedure_id, routing_id, routing_process_id, processing_date, shift_id, status_id)
    found = transaction_summaries.first(:conditions => ["product_id = ? and shift_id = ? and processing_date = ?", product_id, shift_id, processing_date], :lock => true)
    product = Product.find product_id
    if found
      case status_id
      when ProcedureTransaction::GOOD
        found.good_unit += input_quantity
      when ProcedureTransaction::ONHOLD
        found.hold_unit += input_quantity
        ColdStoreAccount.debit_on_hold_summary(input_quantity, product_id, processing_date)
      when ProcedureTransaction::REJECT
        found.reject_unit += input_quantity
      end
      found.part_cost = product.part_cost
      found.save(false)

    else
      new_one = transaction_summaries.create(:product_id => product_id, :employee_id => employee_id, :routing_procedure_id => routing_procedure_id, :routing_id => routing_id, :routing_process_id => routing_process_id, :processing_date => processing_date, :shift_id => shift_id)    
      new_one.lock!
      case status_id
      when ProcedureTransaction::GOOD
        new_one.good_unit += input_quantity
      when ProcedureTransaction::ONHOLD
        new_one.hold_unit += input_quantity
        ColdStoreAccount.debit_on_hold_summary(input_quantity, product_id, processing_date)
      when ProcedureTransaction::REJECT
        new_one.reject_unit += input_quantity
      end
      new_one.part_cost = product.part_cost
      new_one.save(false)
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
  
end
