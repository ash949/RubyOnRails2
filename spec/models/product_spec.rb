require 'rails_helper'

describe Product do
  context "when product has comments" do
    let(:product) { FactoryBot.create(:product) }
    let(:user1) { FactoryBot.build(:user) }
    let(:user2) { FactoryBot.build(:user) }
    let(:user3) { FactoryBot.build(:user) }

    before do
      user1.skip_confirmation!
      user1.save
      user2.skip_confirmation!
      user2.save
      user3.skip_confirmation!
      user3.save
      product.comments.delete_all
      product.comments << FactoryBot.create(:comment, rating: 2, user: user1)
      product.comments << FactoryBot.create(:comment, rating: 4, user: user2)
      product.comments << FactoryBot.create(:comment, rating: 3, user: user3)
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
    it "returns no validation error if name and price_in_cents(>=0) entered" do
      expect(FactoryBot.build(:product, price_in_cents: 1000)).to be_valid
    end

    it "returns validation error if no price_in_cents entered" do
      expect(FactoryBot.build(:product, price_in_cents: nil)).not_to be_valid
    end

    it "returns validation error if price_in_cents wasn't equal or greater than 0" do
      expect(FactoryBot.build(:product, price_in_cents: -1000)).not_to be_valid
    end

    it "returns validation error if no name entered" do
      expect(FactoryBot.build(:product, name: nil)).not_to be_valid
    end
  end
end