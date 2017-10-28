# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.delete_all
Order.delete_all
User.delete_all
OrderProductRecord.delete_all
Branch.delete_all

Product.create([
  {
    name: "product 1",
    image_url: "product.jpg",
    description: "Amazing Product",
    features: "feature 1|||feature 2|||feature 3|||feature 4|||feature 5",
    price: 500.0,
    showcase_images: "product.jpg|||product.jpg|||product.jpg"
  },
  {
    name: "product 2",
    image_url: "product.jpg",
    description: "Amazing Product",
    features: "feature 1|||feature 2|||feature 3|||feature 4|||feature 5",
    price: 450.0,
    showcase_images: "product.jpg|||product.jpg|||product.jpg|||product.jpg|||product.jpg|||product.jpg"
  },
  {
    name: "product 3",
    image_url: "product.jpg",
    description: "Amazing Product",
    features: "feature 1|||feature 2|||feature 3|||feature 4|||feature 5",
    price: 1500.0,
    showcase_images: "product.jpg"
  },
  {
    name: "product 4",
    image_url: "product.jpg",
    description: "Amazing Product",
    features: "feature 1|||feature 2|||feature 3|||feature 4|||feature 5",
    price: 1000.0,
    showcase_images: "product.jpg|||product.jpg"
  }
]);

User.create([
  {first_name: "hamza", last_name: "ashour", email: "hamzaashoor949@hotmail.com", password: "123"},
  {first_name: "hamza2", last_name: "ashour2", email: "hamzaashoor9492@hotmail.com", password: "123"},
  {first_name: "hamza3", last_name: "ashour3", email: "hamzaashoor9493@hotmail.com", password: "123"},
])

Branch.create([
  {
    name: "Branch 1",
    lat: 31.5,
    lng: 31.5
  },
  {
    name: "Branch 2",
    lat: 32.5,
    lng: 32.5
  }
])

#ORM
user = User.first

order = Order.new

user.orders << order

order.products << Product.limit(4)

User.first.orders.first.products



