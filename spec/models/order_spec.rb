require 'rails_helper'

describe Order do
  context 'when an order is created' do
    let(:user) { FactoryBot.build(:user) }

    before do
      user.skip_confirmation!
      user.save
    end

    it 'returns no validation errors if user is provided' do
      expect(FactoryBot.create(:order, user: user)).to be_valid
    end

    it 'returns validation errors if user is not provided' do
      expect(FactoryBot.build(:order, user: nil)).not_to be_valid
    end
  end
end
