json.extract! photo, :id, :caption, :photo_url, :user_id, :toilet_id, :created_at, :updated_at
json.url photo_url(photo, format: :json)
