class MaterialInput < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :material
  has_many :input_machines
  has_many :machines, :through => :input_machines
  
  before_create :change_create_timezone
  before_update :change_update_timezone
  
  validates_presence_of(:lot_number, :quantity, :uom, :material_id)
  validates_numericality_of(:quantity, :message => "must be integer")
  
  attr_protected(:id, :input_date)
  
  private
  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end
  
  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end
  
end
