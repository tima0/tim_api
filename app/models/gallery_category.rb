class GalleryCategory < ActiveRecord::Base

  has_many :gallery_items

  validates :title, presence: true

  after_create :activity_log_create
  after_update :activity_log_update


  def activity_log_create
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.title} gallery category was created by #{admin.name}")
  end

  def activity_log_update
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.title} gallery was updated by #{admin.name}")
  end
end
