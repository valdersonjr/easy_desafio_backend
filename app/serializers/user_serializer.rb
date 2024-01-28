class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email, :profile

  attribute :created_date do |user|
    user.created_at && user.created_at.strftime('%d/%m/%Y')
  end

  def serializable_hash
    data = super
    data[:data].map { |user_data| user_data[:attributes] }
  end
end
