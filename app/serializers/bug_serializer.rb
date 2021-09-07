class BugSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :priority, :status, :comments, :created_at, :updated_at
  belongs_to :user
end
