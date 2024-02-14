def body_json(options = {})
    json = JSON.parse(response.body)
  rescue
    return {}
end

def set_auth_headers(user)
  post '/users/sign_in', params: { user: { email: user.email, password: user.password } }
  headers = response.headers
  @auth_headers = {
    'authorization' => headers['Authorization'],
  }
end
