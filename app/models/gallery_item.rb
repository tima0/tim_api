class GalleryItem < ActiveRecord::Base

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\aimage\/.*\z/

  validates :title, presence: true
  
  belongs_to :gallery_category

  after_create :activity_log_create
  after_update :activity_log_update

  acts_as_taggable


  def activity_log_create
    gallery = Gallery.find(self.gallery_id)
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.title} gallery item was added to the #{gallery.title} by #{admin.name}")
  end

  def activity_log_update
    gallery = Gallery.find(self.gallery_id)
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.title} gallery item was updated in the #{gallery.title} by #{admin.name}")
  end

end
