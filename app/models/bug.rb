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
  
  scope :sorted, lambda { |field, order="asc"| 
    order(field + " " + order)
  }
  
  def self.search(params = {})
    bugs = params[:bug_ids].present? ? Bug.where(id: params[:bug_ids]) : Bug.all
    bugs = bugs.filter_by_title(params[:title]) if params[:title]
    bugs = bugs.equal_to_priority(params[:priority].to_f) if params[:priority]
    bugs = bugs.equal_to_status(params[:status].to_f) if params[:status]
    bugs = bugs.equal_to_reporter(params[:reporter].to_f) if params[:reporter]
    if params[:sort]
      sort_params = params[:sort].to_s.split(",")
      bugs = bugs.sorted(*sort_params)
    end
    
    bugs
  end
end
