# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Comment.delete_all
Product.delete_all
Order.delete_all
Status.delete_all
OrderProduct.delete_all
Branch.delete_all
User.delete_all


Product.create([
  {
    name: "Alienware 1231",
    image_url: "product.jpg",
    description: "Amazing Product",
    features: "CPU: Core i7 7700HQ 4.0GZ|||GPU: GTX 1060|||RAM: 16 GB DDR4 3200MHZ|||SSD: 480GB",
    price_in_cents: 50000,
    showcase_images: "product.jpg|||product.jpg|||product.jpg"
  },
  {
    name: "Razer Blade Pro 2016",
    image_url: "product.jpg",
    description: "Amazing Product",
    features: "CPU: Core i7 7700HQ 4.0GZ|||GPU: GTX 1060",
    price_in_cents: 45000,
    showcase_images: "product.jpg|||product.jpg|||product.jpg|||product.jpg|||product.jpg|||product.jpg"
  },
  {
    name: "Lenovo Ideapad 129",
    image_url: "product.jpg",
    description: "Amazing Product",
    features: "CPU: Core i7 7700HQ 4.0GZ|||GPU: GTX 1060|||RAM: 16 GB DDR4 3200MHZ",
    price_in_cents: 150000,
    showcase_images: "product.jpg"
  },
  {
    name: "MSI G4244",
    image_url: "product.jpg",
    description: "Amazing Product",
    features: "CPU: Core i7 7700HQ 4.0GZ|||GPU: GTX 1060|||RAM: 16 GB DDR4 3200MHZ|||SSD: 480GB",
    price_in_cents: 100000,
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
user1 = User.new(first_name: 'test1', last_name: 'test1', email: 'test1@test1', password: '123123')
user2 = User.new(first_name: 'test2', last_name: 'test2', email: 'test2@test2', password: '123123')
user3 = User.new(first_name: 'admin', last_name: 'admin', email: 'admin@admin', password: '123123')
user3.admin = true

user1.skip_confirmation!
user1.save
user2.skip_confirmation!
user2.save
user3.skip_confirmation!
user3.save

active_status = Status.create!(status_type: 'active')
canceled_status = Status.create!(status_type: 'canceled')
delivered_status = Status.create!(status_type: 'delivered')

order1 = Order.new
order2 = Order.new
order3 = Order.new
order4 = Order.new

order1.status = active_status
order2.status = canceled_status
order3.status = active_status
order4.status = canceled_status

order1.save
order2.save
order3.save
order4.save

product1 = Product.where('name Like ?', 'Alienware 1231').limit(1)
product2 = Product.where('name Like ?', 'Razer Blade Pro 2016').limit(1)
product3 = Product.where('name Like ?', 'Lenovo Ideapad 129').limit(1)
product4 = Product.where('name Like ?', 'MSI G4244').limit(1)

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

Comment.create!(user: user1, product: Product.first, rating: 1, body: 'bad bad bad bad bad bad bad bad bad bad bad bad bad bad bad bad bad bad bad bad bad bad bad ')
Comment.create!(user: user2, product: Product.first, rating: 4, body: "nice nice nice nice nice nice nice nice nice nice nice nice nice nice nice nice nice nice nice nice ")
Comment.create!(user: user3, product: Product.first, rating: 2, body: "meh meh meh meh meh meh meh meh meh meh meh meh meh meh meh meh meh meh meh meh meh meh meh meh ")





