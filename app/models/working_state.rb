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
    save!
  end

  def box_label_creator(employee_id, product_id, machine_id, boxing_date)
    box = BoxLabel.new(:employee_id => employee_id, :product_id => product_id, :machine_id => machine_id, :quantity => maximum_load, :boxed_date_time => Time.now + 8.hours)
    box.code = Engineer.generate_box_label_code(BoxLabel.last)
    box.save!
    label_items.each do |item|
      item.box_label_id = box.id
      item.save!
    end
    LabelEngine.new(box).generate_label_content
    box
  end

  def full?
    loaded_unit >= maximum_load
  end

  def reset
    self.loaded_unit = 0
    save!
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
