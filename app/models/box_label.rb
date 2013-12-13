class BoxLabel < ActiveRecord::Base
	self.record_timestamps = false
	belongs_to :employee
	belongs_to :machine
	belongs_to :product
	has_many   :label_items

	attr_accessible :employee_id, :product_id, :machine_id, :quantity, :boxed_date_time

	delegate :name, :to => :employee, :prefix => true
	delegate :employee_number, :to => :employee, :prefix => false
	delegate :machine_number, :to => :machine
	delegate :part_number, :part_name, :description, :side, :to => :product

	before_create :change_create_timezone
  before_update :change_update_timezone
  

  private

    def change_create_timezone
      self.created_at = Time.now + 8.hours
      self.updated_at = Time.now + 8.hours
    end
  
    def change_update_timezone
      self.updated_at = Time.now + 8.hours
    end

end
