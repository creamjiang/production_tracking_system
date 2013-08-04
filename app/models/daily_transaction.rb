class DailyTransaction < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :routing
  belongs_to :routing_process
  belongs_to :product
  
  attr_accessor :reject_code_id, :left_quantity, :right_quantity, :description
  attr_protected(:id)
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  GOOD = 0
  ONHOLD = -1
  GOOD2 = -2
  REJECT2 = -3
  
  def self.generate_summary(reject_area, selected_product_id, selected_routing_id, selected_routing_process_id, selected_date, reject_code_id, selected_quantity)
    case reject_code_id
      when DailyTransaction::ONHOLD
        reject_code = "Hold"
      when DailyTransaction::GOOD
        reject_code = "Good"
      when DailyTransaction::GOOD2
        reject_code = "Good2"
      when DailyTransaction::REJECT2
        reject_code = "Reject2"
      when 1..9999
        reject = RejectCode.find(reject_code_id)
        reject_code = reject.code
    end
    
    product = Product.find(selected_product_id)
    
    case product.side
      when "Left"
        selected_side = "L"
      when "Right"
        selected_side = "R"
      when "Common"
        selected_side = "C"
    end

    found = DailyTransaction.first(:conditions => ["reject_area = ? and product_id = ? and routing_id = ? and routing_process_id = ? and transaction_date = ? and reject_code = ?", reject_area, selected_product_id, selected_routing_id, selected_routing_process_id, selected_date, reject_code], :lock => true)
    
    if found
      found.quantity += selected_quantity
      found.save!
    else
      DailyTransaction.create(:reject_area => reject_area, :side => selected_side,:generic_name => product.generic_name,:product_id => selected_product_id, :routing_id => selected_routing_id, :routing_process_id => selected_routing_process_id, :transaction_date => selected_date, :reject_code => reject_code, :quantity => selected_quantity)
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
