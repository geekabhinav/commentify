json.array!(@users) do |user|
  json.extract! user, :id, :name, :profile_pic
  json.url user_url(user, format: :json)
end
