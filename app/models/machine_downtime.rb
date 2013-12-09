class MachineDowntime < ActiveRecord::Base
  self.record_timestamps = false
  
  include ActionView::Helpers::DateHelper
  belongs_to :product
  belongs_to :employee
  belongs_to :routing
  belongs_to :routing_process
  belongs_to :routing_procedure
  belongs_to :machine
  belongs_to :bin
  belongs_to :bin_type
  belongs_to :container
  belongs_to :machine_down_reason
  belongs_to :shift
  
  before_create :change_create_timezone
  before_update :change_update_timezone
    
  def up_time
    if fixed
      fixed_time.strftime("%d-%m-%Y %H:%M")
    else
      "Still fixing"
    end
  
  end
    
  def period_of_downtime
    fixed? ? distance_of_time_in_words(fixed_time, created_at) : distance_of_time_in_words(Time.now, created_at) rescue distance_of_time_in_words(Time.now, created_at)
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
