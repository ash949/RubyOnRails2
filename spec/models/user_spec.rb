require 'rails_helper'

describe User do
  context "when user is created" do
    before do
      FactoryBot.create(:user, email: 'test1@test1')
    end
    it "returns no validation error if non-registered-email and password(6 charcters minimum) are provided" do
      expect(FactoryBot.create(:user)).to be_valid
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
    
    it "returns validation error if provided non-registered-emasil with valid password" do
      expect( FactoryBot.build(:user, email: 'test1@test1') ).not_to be_valid
    end
  end
end
