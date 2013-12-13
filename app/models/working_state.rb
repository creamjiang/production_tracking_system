class WorkingState < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :product
  belongs_to :bin
  belongs_to :employee
  belongs_to :routing_procedure
  belongs_to :machine
  belongs_to :attached_product
  belongs_to :bin_type
  has_many   :label_items
  
  attr_protected(:id)
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  
  def loaded_one_unit
    self.loaded_unit += 1
    save(false)
  end

  def box_label_creator(actual_date, emp_id, prod_id, mach_id, input_qty = 0, batch = false)
    input_qty = loaded_unit unless batch
    
    box = BoxLabel.new(:employee_id => emp_id, :product_id => prod_id, :machine_id => mach_id, :quantity => input_qty, :boxed_date_time => Time.now + 8.hours)
    passed_product = Product.find prod_id
    box.code = Engineer.generate_box_label_code(passed_product.part_number, actual_date.delete("-"), input_qty)
    box.save(false)
    unless batch
      label_items.each do |item|
        item.box_label_id = box.id
        item.save(false)
      end
    end
    LabelEngine.new(box).generate_label_content
    box
  end

  def full?
    loaded_unit >= maximum_load
  end

  def empty?
    loaded_unit == 0
  end

  def reset
    self.loaded_unit = 0
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
