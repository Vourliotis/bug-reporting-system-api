class Bug < ApplicationRecord
  validates :title, :priority, :status, presence: true
  enum priority: { minor: 0, major: 1, critical: 2 }
  enum status: { ready: 0, done: 1, rejected: 2 }
  belongs_to :user

  scope :filter_by_title, lambda { |title|
    where('lower(title) LIKE ?', "%#{title.downcase}%")
  }

  scope :equal_to_priority, lambda { |priority|
    if check_integer priority
      where('status = ?', priority)
    else
      where('status = ?', Bug.priorities[priority])
    end
  }

  scope :equal_to_status, lambda { |status|
    if check_integer status
      where('status = ?', status)
    else
      where('status = ?', Bug.statuses[status])
    end
  }

  scope :equal_to_reporter, lambda { |reporter|
    if check_integer reporter
      where(user_id: User.equal_to_role(reporter).ids)
    else
      where(user_id: User.equal_to_role(User.roles[reporter]).ids)
    end
  }

  scope :sorted, lambda { |field, order = 'asc'|
    order(field + ' ' + order)
  }

  def self.search(params = {})
    bugs = params[:bug_ids].present? ? Bug.where(id: params[:bug_ids]) : Bug.all
    bugs = bugs.filter_by_title(params[:title]) if params[:title]
    bugs = bugs.equal_to_priority(params[:priority]) if params[:priority]
    bugs = bugs.equal_to_status(params[:status]) if params[:status]
    bugs = bugs.equal_to_reporter(params[:reporter]) if params[:reporter]
    if params[:sort]
      sort_params = params[:sort].to_s.split(',')
      bugs = bugs.sorted(*sort_params)
    end

    bugs
  end
end
