class Photo < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :reject_code
  has_attached_file :data,
          :styles => {
                       :thumb => "100x100#",
                       :medium => "300x300#"
                     }
                     
                     
  validates_attachment_presence :data, :message => "Please select an image"
  #validates_attachment_content_type :data, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png', 'image/gif', 'image/JPG'], :message => "Please select the correct file type of image"
  before_create :change_create_timezone
  before_update :change_update_timezone

  def self.destroy_pics(reject_code, photos)
    Photo.find(photos, :conditions => {:reject_code_id => reject_code}).each(&:destroy)
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
