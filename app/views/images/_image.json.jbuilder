json.extract! image, :id, :image_data, :user_id, :created_at, :updated_at
json.url image_url(image, format: :json)
json.image_url image.image_data.main.url
