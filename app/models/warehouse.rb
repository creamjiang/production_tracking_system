class Warehouse < ActiveRecord::Base
  self.record_timestamps = false
  has_many :export_items
  has_many :destinations
  #has_many :attached_products
  has_many :routine_products

  before_create :change_create_timezone
  before_update :change_update_timezone
  
  validates_presence_of :name, :location
  validates_uniqueness_of :name, :scope => :location

  def fullname
    name + "-" + location
  end

  def self.options
    
    dummy = Warehouse.new
    dummy.name = "None"
    dummy.location = "None"
    dummy.id = 0
    
    result = all(:order => "name")
    result.insert(0, dummy)
    result.map {|c| [c.fullname, c.id]}
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
