# ---[ News Schema ]---------------------------------------------------
#                        id: [int]
#                     title: [string]
#                   content: [string]
#                  admin_id: [int]
#                    apikey: [string]
#                  url_slug: [string]
#                created_at: [datetime]
#                updated_at: [datetime]

class News < ActiveRecord::Base

  belongs_to :admin

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\aimage\/.*\z/

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true

  before_create :set_token
  after_create :activity_log_create, :set_url
  after_update :activity_log_update

  acts_as_taggable

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
      content: self.content,
      apikey: self.apikey,
      url_slug: self.url_slug,
			created_at: self.created_at, 
			updated_at: self.updated_at
    }   
  end 

  def activity_log_create
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "#{self.title} was added to the news by #{admin.name}")
  end

  def activity_log_update
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "#{self.title} was updated in news by #{admin.name}")
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
    end while News.exists?(column => self[column])
  end
end
