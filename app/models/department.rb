class Department < ActiveRecord::Base

	belongs_to :admin
	has_many :page_categories, -> { order(:sort_order) }
  has_many :citizen_requests

  has_attached_file :cover_image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :cover_image, content_type: /\Aimage\/.*\z/

  validates :name, presence: true, uniqueness: true
  validates :url_slug, uniqueness: true
  validates :admin_id, presence: true

  before_create :set_token
  after_create :activity_log_create, :set_order, :set_url
  after_update :activity_log_update

	scope :sort, lambda{order(:sort_order)}
	scope :published, lambda{where("status = ?", "published")}


  def as_json(options={})

    super(:only => [], 
          :methods => [:public], 
					:include => [{:admin => {:only => [], :methods => :private_profile}},
											 {:page_categories => {:only => [], :methods => :public}}
                      ]   

    )   
  end 

  def public
    {   
      name: self.name,
      description: self.description,
      status: self.status,
      url_slug: self.url_slug,
      apikey: self.apikey,
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
    ActivityLog.create(activity: "The #{self.name} department was created by #{admin.name}")
  end

  def activity_log_update
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.name} department was updated by #{admin.name}")
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
		url = self.name.parameterize.underscore
		self.update_attribute(:url_slug, url)
	end

end
