require 'rails_helper'

describe CommentsController, type: :controller do
  
  context "DELETE #destroy:" do
    
    let(:product) { FactoryBot.create(:product) }
    let(:user1) { FactoryBot.create(:user) }
    let(:admin) { FactoryBot.create(:admin) }

    before do

      product.comments << FactoryBot.create(:comment, user: user1)
    end

    it "not authorized - non-admin logged_in user, redirected to root page" do
      sign_in user1
      delete :destroy, params: {product_id: product.id, id: product.comments.first.id}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "not authenticated - non-admin not logged_in user, redirected to login page" do
      delete :destroy, params: {product_id: product.id, id: product.comments.first.id}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "comment destroyed - admin user can delete a product, redirected to products page" do
      sign_in admin
      delete :destroy, params: {product_id: product.id, id: product.comments.first.id}
      expect(product.comments.reload.size).to eq(0)
      expect(response).to redirect_to product_path(product.id)
    end
  end

  #=======================================================================================
  context "POST #create:" do
    let(:product) { FactoryBot.create(:product) }
    let(:user1) { FactoryBot.create(:user) }
    let(:user2) { FactoryBot.create(:user) }

    before do
      product.comments << FactoryBot.create(:comment, user: user1)
    end

    it "comment added - authenticated user and haven't commented on this product - logged_in user, comment added and user redirected to product's page" do
      sign_in user2
      post :create, params: {product_id: product.id, user_id: user2.id, comment: {body: 'bad bad bad bad', rating: 1}}
      expect(response).to redirect_to product_path(product.id)
    end

    it "comment not added - authenticated and have commented on this product - logged_in user, comment not created and user redirected to product's page" do
      sign_in user1
      post :create, params: {product_id: product.id, user_id: user1.id, comment: {body: 'bad bad bad bad', rating: 1}}
      expect(product.comments.reload.size == 1).to eq(true)
      expect(response).to redirect_to product_path(product.id)
    end

    it "not authenticated - not logged_in user, redirected to login_page" do
      post :create, params: {product_id: product.id, user_id: user1.id, comment: {body: 'bad bad bad bad', rating: 1}}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end
  end
end