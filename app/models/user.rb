class User < ApplicationRecord
  validates :email, uniqueness: true
  validates_format_of :email, with: /@/
  validates :password_digest, presence: true
  has_secure_password
  enum role: { qa: 0, po: 1, dev: 2, admin: 3 }
  has_many :bugs, dependent: :destroy

  scope :equal_to_role, lambda { |role| 
    where('role = ?', role)
  }
end
