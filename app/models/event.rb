# ---[ Event Schema ]---------------------------------------------------
#                        id: [int]
#                     title: [string]
#               description: [string]
#                    status: [string]    (active, inactive)
#                  admin_id: [int]
#                start_time: [datetime]
#                  end_time: [datetime]
#                    apikey: [string]
#                  url_slug: [string]
#                created_at: [datetime]
#                updated_at: [datetime]
#     cover_image_file_name: [string]
#  cover_image_content_type: [string]
#     cover_image_file_size: [int]
#    cover_image_updated_at: [datetime]

class Event < ActiveRecord::Base

  require 'active_support/core_ext/string/conversions'

  belongs_to :admin

  has_attached_file :cover_image,
                    styles: {medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :cover_image, content_type: /\Aimage\/.*\z/

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true
  validates :admin_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  before_create :set_token
  after_create :activity_log_create, :set_url
  after_update :activity_log_update

  acts_as_taggable

  # Define some scopes to make querying consistent and easy
  scope :status, ->(status) { where('status = ?', status) if status.present? }
  scope :start_after, ->(datetime) { where('start_time >= ?', datetime.to_datetime) if datetime.present? }
  scope :end_before, ->(datetime) { where('end_time <= ?', datetime.to_datetime) if datetime.present? }
  scope :admin_is, -> (admin) { where('admin_id = ?', admin) if admin.present? }

  def as_json(options={})

    super(:only => [], 
          :methods => [:public], 
					:include => [{:admin => {:only => [], :methods => :private_profile}}
                      ]   
    )   
  end 

  def public
    {   
      title: self.title,
      description: self.description,
      start_time: self.start_time,
      end_time: self.end_time,
      status: self.status,
      apikey: self.apikey,
      url_slug: self.url_slug,
      tags: self.tags,
			cover_image_file_name: self.cover_image_file_name,
			cover_image_content_type: self.cover_image_content_type,
			cover_image_file_size: self.cover_image_file_size,
			cover_image_updated_at: self.cover_image_updated_at,
			created_at: self.created_at, 
			updated_at: self.updated_at
    }   
  end 

  def activity_log_create
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "#{self.title} was added to events by #{admin.name}")
  end

  def activity_log_update
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "#{self.title} was updated in events by #{admin.name}")
  end

	def set_url
		url = self.title.parameterize.underscore
		self.update_attribute(:url_slug, url)
	end

  def set_token
    generate_token(:apikey)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.hex
    end while Event.exists?(column => self[column])
  end
end
