json.extract! user, :id, :name, :nickname, :email, :birthdate, :country, :created_at, :updated_at
json.url user_url(user, format: :json)
