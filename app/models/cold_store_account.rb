class ColdStoreAccount < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :product
  attr_protected(:id)
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  def self.debit_on_hold_summary(input_quantity, product_id, report_date)
    found = self.first(:conditions => ["product_id = ? and report_on = ?", product_id, report_date])
    if found
      found.debit += input_quantity
      found.save
    else
      ColdStoreAccount.create(:product_id => product_id, :report_on => report_date, :debit => input_quantity)
    end
  end
  
  def self.credit_on_hold_summary(input_quantity, product_id, report_date)
    found = self.first(:conditions => ["product_id = ? and report_on = ?", product_id, report_date])
    if found
      found.credit += input_quantity
      found.save!
    else
      ColdStoreAccount.create(:product_id => product_id, :report_on => report_date, :credit => input_quantity)
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
