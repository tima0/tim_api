class Page < ActiveRecord::Base
  
  belongs_to :page_category
	belongs_to :department

  has_attached_file :cover_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :cover_image, content_type: /\Aimage\/.*\z/

  validates :title, presence: true

  before_create :set_token
  after_create :activity_log_create, :set_order, :set_url
  after_update :activity_log_update

  acts_as_taggable

  def as_json(options={}) 
    super(:only => [],
      :methods => [:public], 
			:include => [{:page_category => {:only => [], :methods => :public}},
									 {:department => {:only => [], :methods => :public}}
									]
    )
  end

  def public
    {
      :title => self.title,
      :body => self.body,
      :url_slug => self.url_slug,
      :apikey => self.apikey
    }
  end

  def activity_log_create
    category = PageCategory.find(self.page_category_id)
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.title} page was created in #{category.title} by #{admin.name}")
  end

  def activity_log_update
    category = PageCategory.find(self.page_category_id)
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.title} page was updated in #{category.title} by #{admin.name}")
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
    end while Page.exists?(column => self[column])
  end

	def set_url
		url = self.title.parameterize.underscore
		self.update_attribute(:url_slug, url)
	end
end
