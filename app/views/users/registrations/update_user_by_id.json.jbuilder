json.message 'User updated successfully'
json.user do
  json.id @user.id
  json.email @user.email
  json.profile @user.profile
end
