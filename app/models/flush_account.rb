class FlushAccount < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :procedure_transaction
  belongs_to :export_item
  
  before_create :change_create_timezone
  after_update :change_update_timezone
  
   private

  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end

  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end
end
