class Bin < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :bin_type
  belongs_to :bin_status
  has_one :working_state
  has_many :procedure_transactions
  has_many :bin_clearing_records
  has_many :machine_downtimes
  
  attr_accessible :bin_number, :bin_type_id, :description
  #validates_presence_of :bin_number
  #validates_uniqueness_of :bin_number
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  named_scope :full, lambda { |bin_type| {:conditions => ["bin_status_id = ? and bin_type_id = ?", BinStatus::FULL, bin_type.id]}}

  def self.check_available_bin(product)
    found = Container.first(:conditions => ["product_id = ?", product.id])
    if found
      bin = Bin.find_or_create_by_bin_type_id(found.bin_type_id)
    else
      bt = BinType.find_or_create_by_name(product.part_name.strip + " converyer")
      Container.create(:product_id => product.id, :bin_type_id => bt.id)
      bin = Bin.create(:bin_type_id => bt.id, :bin_number => bt.name)
    end
    bin

  end

  def check_bin_status(working_state, container)
    if working_state.total_unit < container.maximum_load
      unless bin_status_id == BinStatus::USED
        self.bin_status_id = BinStatus::USED
        save  
      end
    elsif working_state.total_unit >= container.maximum_load
      unless bin_status_id == BinStatus::FULL
        self.bin_status_id = BinStatus::FULL
        save
        working_state.destroy
      end
    end
  end
  
  
  def clear_bin(emp_id)
    self.bin_status_id = BinStatus::AVAILABLE
    save
    BinClearingRecord.create(:employee_id => emp_id, :bin_id => id)
  end
  
  
  def verify_for_destroy
   deleted = false
      if procedure_transactions.size.zero?
        if bin_clearing_records.size.zero?
          if machine_downtimes.size.zero?
            destroy
            deleted = true
          end
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
