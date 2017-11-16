require 'rails_helper'

describe User do
  context "when user is created" do
    let(:user) { FactoryBot.build(:user) }
    it "returns no validation error if non-registered-email and password(6 charcters minimum) are provided" do
      user.password = '123123'
      user.skip_confirmation!
      expect( user.save ).to eq(true)
    end

    it "returns validation error if provided non-registered-email with no password" do
      expect(FactoryBot.build(:user, password: nil)).not_to be_valid
    end

    it "returns validation error if provided password with no email" do
      expect(FactoryBot.build(:user, email: nil)).not_to be_valid
    end

    it "returns validation error if provided password(6 charcters minimum) with no non-registered-email" do
      expect(FactoryBot.build(:user, password: '12345')).not_to be_valid
    end
    
    it "returns validation error if provided non-registered-email with valid password" do
      user.password = '123123'
      user.skip_confirmation!
      user.save
      expect( FactoryBot.build(:user, email: User.take.email) ).not_to be_valid
    end
  end
end
