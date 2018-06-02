class ActivityLog < ActiveRecord::Base

  validates :activity, presence: true

  scope :last_7, -> { where('created_at >= ?', 1.week.ago) }
  scope :last_30, -> { where('created_at >= ?', 1.month.ago) }
  
  def as_json(options={})
    {   
      activity: self.activity,
      created_at: self.created_at,
    }   
  end 

end
