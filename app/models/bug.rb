class Bug < ApplicationRecord
  validates :title, :priority, :status, presence: true
  enum priority: { minor: 0, major: 1, critical: 2 }
  enum status: { ready: 0, done: 1, rejected: 2 }
  belongs_to :user

  scope :filter_by_title, lambda { |title| 
    where('lower(title) LIKE ?', "%#{title.downcase}%")
  }

  scope :equal_to_priority, lambda { |priority| 
    where('priority = ?', priority)
  }

  scope :equal_to_status, lambda { |status| 
    where('status = ?', status)
  }

  scope :equal_to_reporter, lambda { |reporter| 
    where('user_id = ?', User.equal_to_role(reporter).ids)
  }
end
