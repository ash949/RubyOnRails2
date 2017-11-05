require 'rails_helper'
Rails.env = ENV['RAILS_ENV'] = 'test'

describe Product do
  context "when product has comments" do
    let(:product) { Product.create!(name: "Mac book 2017", price: 3000) }
    let(:user1) {
      User.create!(email: 'test4@test4', password: '123123')
    }

    let(:user2) {
      User.create!(email: 'test5@test5', password: '123123')
    }

    let(:user3) {
      User.create!(email: 'test6@test6', password: '123123')
    }
    before do
      product.comments.create!(body: "bad laptop", rating: 2, user: user1)
      product.comments.create!(body: "Best laptop I have ever bought", rating: 4, user: user2)
      product.comments.create!(body: "Overpriced laptop but fine", rating: 3, user: user3)
    end

    it "returns the average rating of all comments" do
      expect(product.compute_average).to eq 3
    end

    it "returns the highest rating of all comments" do
      expect(product.highest_rating_comment.rating).to eq 4
    end

    it "returns the lowest rating of all comments" do
      expect(product.lowest_rating_comment.rating).to eq 2
    end
  end

  context "when a product is created" do
    it "returns no validation error if name and price(>=0) entered" do
      expect(Product.new(name:'laptop 1', price: 500)).to be_valid
    end

    it "returns validation error if no price entered" do
      expect(Product.new(name: 'laptop 1')).not_to be_valid
    end

    it "returns validation error if price wasn't equal or greater than 0" do
      expect(Product.new(name: 'laptop 1', price: -10)).not_to be_valid
    end

    it "returns validation error if no name entered" do
      expect(Product.new(price: 500)).not_to be_valid
    end
  end
end