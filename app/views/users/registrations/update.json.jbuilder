json.message 'User updated successfull'
json.user do
  json.id @user.id
  json.email @user.email
  json.profile @user.profile
end
