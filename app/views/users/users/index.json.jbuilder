json.users @users do |user|
  json.id user.id
  json.name user.name
  json.email user.email
  json.profile user.profile
  json.created_at user.created_at
end

json.pagination_meta @pagination_meta
