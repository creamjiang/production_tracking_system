class AccountStatement < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :routing_procedure
  belongs_to :routing_process
  belongs_to :routing
  belongs_to :product
  has_many :export_items


  before_create :check_ids
  before_create :change_create_timezone
  before_update :change_update_timezone

  def closing_balance
    opening_balance + quantity_in - quantity_out
  end

   private

  def check_ids
    self.routing_process_id = routing_procedure.routing_process_id if routing_procedure
    self.routing_id = routing_procedure.routing_id if routing_procedure
    self.generic_name = product.generic_name if product
  end

  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end

  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end

end
