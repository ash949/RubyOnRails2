require 'rails_helper'
Rails.env = ENV['RAILS_ENV'] = 'test'

describe User do
  context "when user is created" do
    let (:user) { User.where("email LIKE 'test4@test4'")}
    it "returns no validation error if non-registered-email and password(6 charcters minimum) are provided" do
      expect(User.new(email: 'testnew@testnew', password: '123123')).to be_valid
    end

    it "returns validation error if provided non-registered-email with no password" do
      expect(User.new(email: 'testnew@testnew')).not_to be_valid
    end

    it "returns validation error if provided password(6 charcters minimum) with no non-registered-email" do
      expect(User.new(password: '123123')).not_to be_valid
    end
    
    it "returns validation error if provided non-registered-email with password length of less than 6" do
      expect(User.new(email: 'testnew@testnew', password: '12312')).not_to be_valid
    end

  end
end
