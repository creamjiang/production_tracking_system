class Destination < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :warehouse
  has_many :export_items

  before_create :change_create_timezone
  before_update :change_update_timezone

  validates_presence_of :name, :location, :warehouse_id

  def fullname
    name + "-" + location
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
