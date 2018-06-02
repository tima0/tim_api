# ---[ Document Schema ]---------------------------------------------------
#                        id: [int]
#                     title: [string]
#               description: [string]
#                  admin_id: [int]
#                    apikey: [string]
#                  file_url: [string]
#                 file_type: [string]
#                created_at: [datetime]
#                updated_at: [datetime]

class Document < ActiveRecord::Base

  belongs_to :admin

  validates :title, presence: true, uniqueness: true
  validates :file_url, presence: true
  validates :file_type, presence: true

  before_create :set_token
  after_create :activity_log_create, :set_order
  after_update :activity_log_update

  acts_as_taggable

	scope :sort, lambda{order(:sort_order)}

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
      file_type: self.file_type,
      file_url: self.file_url,
      apikey: self.apikey,
			created_at: self.created_at, 
			updated_at: self.updated_at
    }   
  end 

  def activity_log_create
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.title} document was created by #{admin.name}")
  end

  def activity_log_update
    admin = Admin.find(self.admin_id)
    ActivityLog.create(activity: "The #{self.title} document was updated by #{admin.name}")
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
    end while Document.exists?(column => self[column])
  end
end
