class CitizenRequest < ActiveRecord::Base

  belongs_to :user
  belongs_to :department

  validates :user_id, presence: true
  validates :department_id, presence: true
  validates :request, presence: true

  after_create :activity_log_create

  acts_as_taggable

  def activity_log_create
    user = User.find(self.user_id)
    ActivityLog.create(activity: "A citizen request was created by #{user.name}")
  end

end
