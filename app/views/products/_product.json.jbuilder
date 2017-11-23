json.extract! product,
              :id, :name, :image_url, :description, :features, :price,
              :showcase_images, :created_at, :updated_at
json.url product_url(product, format: :json)
