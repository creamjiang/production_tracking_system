class AttachedProduct < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :machine
  belongs_to :product
  belongs_to :routing_procedure
  belongs_to :routing
  belongs_to :routing_process
  belongs_to :bin_type
  #belongs_to :warehouse
  has_many :working_states
  
  attr_protected(:id)
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  before_save :check_ids

  named_scope(:active, :joins => :product, :conditions => { :visible => true }, :order => "products.part_number")
  named_scope(:active_for_machine, lambda {|machine_id| {:conditions => ["visible = true and machine_id = ?", machine_id]}})

  

  private

  def check_ids
    self.routing_process_id = routing_procedure.routing_process_id if routing_procedure
    self.routing_id = routing_procedure.routing_id if routing_procedure
    self.part_name = product.part_name if product
  end

  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end
  
  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end
end
