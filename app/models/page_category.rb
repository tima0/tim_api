class PageCategory < ActiveRecord::Base

  has_many :pages, -> { order(:sort_order) }
	belongs_to :department

  has_attached_file :cover_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :cover_image, content_type: /\Aimage\/.*\z/

  validates :title, presence: true, uniqueness: true

  before_create :set_token
  after_create :activity_log_create, :set_order, :set_url
  after_update :activity_log_update

	scope :sort, lambda{order(:sort_order)}

  def as_json(options={}) 
    super(:only => [],
      :methods => [:public], 
			:include => [{:pages => {:only => [], :methods => :public}},
									 {:department => {:only => [], :methods => :public}}
									]
    )
  end

  def public
    {
      :title => self.title,
      :body => self.body,
      :url_slug => self.url_slug,
      :apikey => self.apikey,
      :cover_image_file_name => self.cover_image_file_name,
      :cover_image_content_type => self.cover_image_content_type,
      :cover_image_file_size => self.cover_image_file_size,
      :cover_image_updated_at => self.cover_image_updated_at,
    }
  end

  def activity_log_create
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.title} page category was created by #{admin.name}")
  end

  def activity_log_update
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.title} page category was updated by #{admin.name}")
  end

  def set_order
    self.update_attribute(:sort_order, self.id)
  end

  def set_token
    generate_token(:apikey)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.hex
    end while Department.exists?(column => self[column])
  end

	def set_url
		url = self.title.parameterize.underscore
		self.update_attribute(:url_slug, url)
	end

end
