require 'rails_helper'

describe Order do
  context "when an order is created" do
    let(:user1) { FactoryBot.build(:user) }
    it "returns no validation errors if user is provided" do
      expect( FactoryBot.create(:order, user: user1) ).to be_valid
    end

    it "returns validation errors if user is not provided" do
      expect( FactoryBot.build(:order, user: nil) ).not_to be_valid
    end
  end
end
