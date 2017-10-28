# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.create({
  name: "product 1",
  image_url: "product.jpg",
  description: "Amazing Product",
  features: "feature 1|||feature 2|||feature 3|||feature 4|||feature 5",
  price: 500.0,
  showcase_images: "product.jpg|||product.jpg|||product.jpg"
});

User.create([
  {first_name: "hamza", last_name: "ashour", email: "hamzaashoor949@hotmail.com", password: "123"},
  {first_name: "hamza2", last_name: "ashour2", email: "hamzaashoor9492@hotmail.com", password: "123"},
  {first_name: "hamza3", last_name: "ashour3", email: "hamzaashoor9493@hotmail.com", password: "123"},
])

order = User.find(1).orders.create({user_id: User.find(1).id})

order.order_product_records.create([
  {product_id: Product.find(1).id},
  {product_id: Product.find(2).id},
  {product_id: Product.find(3).id},
  {product_id: Product.find(4).id}
])




