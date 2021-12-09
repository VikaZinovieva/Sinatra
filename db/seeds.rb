auth_data = [
  { username: 'superadmin', password: '12345' }
]

auth_data.each do |u|
  Auth.create(u)
end
