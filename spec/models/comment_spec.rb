require 'rails_helper'

describe Comment do
  context "when a comment is created" do
    let(:product) { Product.create!(name: "Mac book 2016", price: 2000) }
    let(:user) { User.create!(email: "test7@test7", password: '123123') }

    it "returns no validation error if body and rating(integer) entered with product and user" do
      expect( product.comments.new(body:'test comment', rating: 4, user: user) ).to be_valid
    end

    it "returns validation error if body is missing" do
      expect( product.comments.new(rating: 4, user: user) ).not_to be_valid
    end

    it "returns validation error if rating is missing" do
      expect( product.comments.new(body:'test comment',user: user) ).not_to be_valid
    end

    it "returns validation error if user is missing" do
      expect( product.comments.new(body:'test comment',rating: 4) ).not_to be_valid
    end

    it "returns validation error if user has already reviewed the same product" do
      product.comments.create!(body:'test comment', rating: 4, user: user)
      expect( product.comments.new(body:'test comment', rating: 4, user: user) ).not_to be_valid
    end
  end
end