class Bug < ApplicationRecord
  validates :title, :priority, :status, presence: true
  enum priority: { minor: 0, major: 1, critical: 2 }
  enum status: { ready: 0, done: 1, rejected: 2 }
  belongs_to :user
end
