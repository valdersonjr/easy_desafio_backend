class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :created_at

  attribute :created_date do |user|
    user.created_at && user.created_at.strftime('%d/%m/%Y')
  end

  def serializable_hash
    data = super
    data.is_a?(Hash) ? data.values.first : data
  end
end
