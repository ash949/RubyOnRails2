require 'rails_helper'
Rails.env = ENV['RAILS_ENV'] = 'test'

describe Order do
  context "when an order is created" do
    let(:user) { User.create!(email: 'test11@test11', password: '123123') }
    it "returns no validation errors if user is provided" do
      expect(user.orders.new()).to be_valid
    end

    it "returns validation errors if user is not provided" do
      expect(Order.new()).not_to be_valid
    end
  end
end
