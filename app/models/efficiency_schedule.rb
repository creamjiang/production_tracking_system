class EfficiencySchedule < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :product
  belongs_to :machine_down_reason 

  before_create :assign_value
  after_create  :calculate_duration
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  validates_numericality_of :expected_output, :operators_present
  validates_presence_of :expected_output, :operators_present, :schedule_date
  validates_presence_of :down_reason_code, :if => :is_breakdown?

  def attached_product_id
    @attached_id
  end

  def attached_product_id=(value)
    @attached_id = value
    self.product_id = AttachedProduct.find(@attached_id.to_i).product_id rescue nil
  end
  

  protected
  def validate
    passed = true
    checking_targets = EfficiencySchedule.all(:conditions => ["schedule_date = ? and product_id = ?", schedule_date, product_id])
    checking_targets.each do |c|
      target_start_time = Time.parse(c.schedule_date.to_s + " " + c.start_time.strftime("%H:%M:00"))
      if c.end_time.min == 0
        target_end_time = Time.parse((c.schedule_date + 1.day).to_s + " " + c.end_time.strftime("%H:%M:00"))
      else
        target_end_time = Time.parse(c.schedule_date.to_s + " " + c.end_time.strftime("%H:%M:00"))
      end
        passed = false if (target_start_time..(target_end_time)).include?(Time.parse(schedule_date.to_s + " " + start_time.strftime("%H:%M:00")))
    end
    
    errors.add_to_base("Running Period overlap !") unless passed unless is_breakdown?
    errors.add_to_base("Part Name cannot be blank !") if product_id.nil? or product_id.blank?
  end

  private

  def assign_value
    if machine_down_reason
      self.down_reason_code = machine_down_reason.code
    else
      self.machine_down_reason_id = 0
    end
    self.part_name = product.part_name if product

  end

  def is_breakdown?
    operation_status == "Breakdown"
  end

  def calculate_duration
    self.start_time = Time.parse(schedule_date.to_s + " " + start_time.strftime("%H:%M:00"))
    if end_time.min == 0
      self.end_time = Time.parse((schedule_date + 1.day).to_s + " " + end_time.strftime("%H:%M:00"))
    else
      self.end_time = Time.parse(schedule_date.to_s + " " + end_time.strftime("%H:%M:00"))
    end

    self.duration = (end_time - start_time) / 60
    save!
  end

  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end

  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end
end
