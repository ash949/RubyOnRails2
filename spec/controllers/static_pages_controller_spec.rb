require 'rails_helper'

get_actions = [[:index, 'index'], [:contact, 'contact'], [:about, 'about']]

describe StaticPagesController, type: :controller do
  get_actions.each do |action|
    describe "GET ##{action[1]}" do
      it "renders the #{action[1]} template" do
        get action[0]
        expect(response).to be_ok
        expect(response).to render_template(action[1])
      end
    end
  end
end
