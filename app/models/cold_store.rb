class ColdStore < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :procedure_transaction
  belongs_to :product
  attr_accessible :quantity, :procedure_transaction_id, :on_hold_date, :converted_date, :status, :product_id, :administrator_id
  
  named_scope :on_hold_stock, lambda { { :conditions => ['status = ?', ProcedureTransaction::ONHOLD] } }
  named_scope :by_product, lambda {|c| { :conditions => ['product_id = ?', c] } }
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  def self.product_quantity(input_product_id)
    total = on_hold_stock.by_product(input_product_id).all.inject(0) {|sum, c| sum+=c.quantity }
    total.to_i
  end
  
  def status_name
    case status
      when ProcedureTransaction::ONHOLD
        "On Hold"
      when ProcedureTransaction::GOOD2
        "Accept"
      when ProcedureTransaction::REJECT2
        "Reject"
      else
        "Unknown"
      end
    
  end
  
  def self.convert_to_good_unit(selected_attached_product, convert_unit, convert_date, admin_id)
    
    added_unit = 0
    transaction do
      while convert_unit > 0
        hold_unit = first(:conditions => ["status = ? and product_id = ?", ProcedureTransaction::ONHOLD, selected_attached_product.product_id], :lock => true)
        if hold_unit
          if convert_unit >= hold_unit.quantity
            added_unit += hold_unit.quantity
            convert_unit -= hold_unit.quantity
            hold_unit.convert_to_good_unit(selected_attached_product, hold_unit.quantity, convert_date, admin_id)
            DailyTransaction.generate_summary("00", selected_attached_product.product_id, selected_attached_product.routing_id, selected_attached_product.routing_process_id, convert_date, DailyTransaction::GOOD2, hold_unit.quantity)

          elsif convert_unit < hold_unit.quantity
            added_unit += convert_unit
            hold_unit.convert_to_good_unit(selected_attached_product, convert_unit, convert_date, admin_id)
            DailyTransaction.generate_summary("00", selected_attached_product.product_id, selected_attached_product.routing_id, selected_attached_product.routing_process_id, convert_date, DailyTransaction::GOOD2, convert_unit)
            convert_unit = 0
          end
       else
         break
       end
      end
    end
    msg = added_unit.to_s + " units successfully added to Good unit"   
    msg
  end
  
  def self.convert_to_reject_unit(selected_attached_product, convert_unit, convert_date, admin_id)
    added_unit = 0
    transaction do
      while convert_unit > 0
        hold_unit = first(:conditions => ["status = ? and product_id = ?", ProcedureTransaction::ONHOLD, selected_attached_product.product_id], :lock => true)
        if hold_unit
          if convert_unit >= hold_unit.quantity
            added_unit += hold_unit.quantity
            convert_unit -= hold_unit.quantity
            hold_unit.convert_to_reject_unit(selected_attached_product, hold_unit.quantity, convert_date, admin_id)
            DailyTransaction.generate_summary("99", selected_attached_product.product_id, selected_attached_product.routing_id, selected_attached_product.routing_process_id, convert_date, DailyTransaction::REJECT2, hold_unit.quantity)

          elsif convert_unit < hold_unit.quantity
            added_unit += convert_unit
            hold_unit.convert_to_reject_unit(selected_attached_product, convert_unit, convert_date, admin_id)
            DailyTransaction.generate_summary("99", selected_attached_product.product_id, selected_attached_product.routing_id, selected_attached_product.routing_process_id, convert_date, DailyTransaction::REJECT2, convert_unit)
            convert_unit = 0
          end
       else
         break
       end
      end
    end
    msg = added_unit.to_s + " units successfully added to Reject unit"   
    msg
  end
  
  def convert_to_good_unit(attached_product, amount, current_date, admin_id)
    check = quantity - amount
    if check == 0
      self.status = ProcedureTransaction::GOOD2
      self.converted_date = current_date
      self.administrator_id = admin_id
      self.quantity = amount
    elsif check > 0
      c = ColdStore.new(:status => ProcedureTransaction::GOOD2, :converted_date => current_date, :administrator_id => admin_id)
      c.procedure_transaction_id = procedure_transaction_id
      c.on_hold_date = on_hold_date
      c.product_id = product_id
      c.quantity = amount
      c.save!
      self.quantity -= amount
    end
    save!
    t = procedure_transaction
    convert_time = Time.parse(current_date.strftime("%Y-%m-%d") + " " + Time.now.strftime("%H:%M:%S")) + 8.hours
    if t
      ProcedureTransaction.create!(:created_at => convert_time, :quantity => amount, :product_id => t.product_id, :employee_id => t.employee_id, :routing_procedure_id => t.routing_procedure_id, :routing_id => t.routing_id, :routing_process_id => t.routing_process_id, :machine_id => t.machine_id, :bin_id => t.bin_id, :bin_type_id => t.bin_type_id, :status => ProcedureTransaction::GOOD2, :transaction_date => current_date, :shift_id => t.shift_id, :container_id => t.container_id)
    else
      ProcedureTransaction.create!(:created_at => convert_time, :quantity => amount, :product_id => attached_product.product_id, :employee_id => admin_id, :routing_procedure_id => attached_product.routing_procedure_id, :routing_id => attached_product.routing_id, :routing_process_id => attached_product.routing_process_id, :machine_id => 0, :bin_id => 0, :bin_type_id => 0, :status => ProcedureTransaction::GOOD2, :transaction_date => current_date, :shift_id => 0, :container_id => 0)
    end
    ColdStoreAccount.credit_on_hold_summary(amount, product_id, current_date)
    
  end
  
  def convert_to_reject_unit(attached_product, amount, current_date, admin_id)
    check = quantity - amount
    
    if check == 0
      self.status = ProcedureTransaction::REJECT2
      self.converted_date = current_date
      self.administrator_id = admin_id
      self.quantity = amount
    elsif check > 0
      c = ColdStore.new(:status => ProcedureTransaction::REJECT2, :converted_date => current_date, :administrator_id => admin_id)
      c.procedure_transaction_id = procedure_transaction_id
      c.on_hold_date = on_hold_date
      c.product_id = product_id
      c.quantity = amount
      c.save!
      self.quantity -= amount
    end
      save!
      t = procedure_transaction
      convert_time = Time.parse(current_date.strftime("%Y-%m-%d") + " " + Time.now.strftime("%H:%M:%S")) + 8.hours
      if t
        ProcedureTransaction.create!(:created_at => convert_time, :quantity => amount, :product_id => t.product_id, :employee_id => t.employee_id, :routing_procedure_id => t.routing_procedure_id, :routing_id => t.routing_id, :routing_process_id => t.routing_process_id, :machine_id => t.machine_id, :bin_id => t.bin_id, :bin_type_id => t.bin_type_id, :status => ProcedureTransaction::REJECT2, :transaction_date => current_date, :shift_id => t.shift_id, :reject_code_id => 0, :container_id => t.container_id)
      else
        ProcedureTransaction.create!(:created_at => convert_time, :quantity => amount, :product_id => attached_product.product_id, :employee_id => admin_id, :routing_procedure_id => attached_product.routing_procedure_id, :routing_id => attached_product.routing_id, :routing_process_id => attached_product.routing_process_id, :machine_id => 0, :bin_id => 0, :bin_type_id => 0, :status => ProcedureTransaction::REJECT2, :transaction_date => current_date, :shift_id => 0, :reject_code_id => 0, :container_id => 0)
      end
      ColdStoreAccount.credit_on_hold_summary(amount, product_id, current_date)
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
