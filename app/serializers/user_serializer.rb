class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :role
  has_many :bugs
end
