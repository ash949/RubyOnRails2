# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.delete_all
Order.delete_all
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
user1 = User.first
user2 = User.last

order1 = Order.new
order2 = Order.new
order3 = Order.new
order4 = Order.new

product1 = Product.where('name Like ?', 'product 1')
product2 = Product.where('name Like ?', 'product 2')
product3 = Product.where('name Like ?', 'product 3')
product4 = Product.where('name Like ?', 'product 4')

user1.orders << order1
user1.orders << order2

user1.orders.first.products << product1
user1.orders.first.products << product2
user1.orders.first.products << product3

user1.orders.last.products << product1
user1.orders.last.products << product4

user2.orders << order3
user2.orders << order4

user2.orders.first.products << product1
user2.orders.first.products << product2
user2.orders.first.products << product3

user2.orders.last.products << product1
user2.orders.last.products << product4





