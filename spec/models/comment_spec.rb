require 'rails_helper'

describe Comment do
  context 'when a comment is created' do
    let(:product) { FactoryBot.build(:product) }
    let(:user) { FactoryBot.build(:user) }

    before do
      user.skip_confirmation!
      user.save
    end

    it 'returns no validation error if
        body and rating(integer) entered with product and user' do
      expect(
        FactoryBot.build(:comment, product: product, user: user)
      ).to be_valid
    end

    it 'returns validation error if
        body is missing' do
      expect(
        FactoryBot.build(:comment, product: product, body: nil, user: user)
      ).not_to be_valid
    end

    it 'returns validation error if
        rating is missing' do
      expect(
        FactoryBot.build(:comment, product: product, rating: nil, user: user)
      ).not_to be_valid
    end

    it 'returns validation error if
        user is missing' do
      expect(
        FactoryBot.build(:comment, product: product, user: nil)
      ).not_to be_valid
    end

    it 'returns validation error if
        user has already reviewed the same product' do
      product.comments << FactoryBot.create(:comment, user: user)
      expect(
        FactoryBot.create(:comment, product: product, user: user)
      ).not_to be_valid
    end
  end
end
