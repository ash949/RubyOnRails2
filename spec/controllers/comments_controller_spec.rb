require 'rails_helper'

describe CommentsController, type: :controller do
  
  context "DELETE #destroy:" do
    
    let(:product) { Product.create!(name: 'Laptop 1', price: 500) }
    let(:user1) { User.create!(email: 'test1@test1', password: '123123') }
    let(:admin) { User.create!(email: 'admin@admin', password: '123123', admin: true) }

    before do
      product.comments.create!(body: "bad laptop", rating: 2, user: user1)
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
      expect(Comment.all.length == 0).to eq(true)
      expect(response).to redirect_to product_path(product.id)
    end
  end

  #=======================================================================================
  context "POST #create:" do
    let(:product) { Product.create!(name: 'Laptop 1', price: 500) }
    let(:user1) { User.create!(email: 'test1@test1', password: '123123') }
    let(:user4) { User.create!(email: 'test4@test4', password: '123123') }
    let(:admin) { User.create!(email: 'admin@admin', password: '123123', admin: true) }

    before do
      product.comments.create!(body: "bad laptop", rating: 2, user: user1)
    end

    it "comment added - authenticated user and haven't commented on this product - logged_in user, comment added and user redirected to product's page" do
      sign_in user4
      post :create, params: {product_id: product.id, user_id: user4.id, comment: {body: 'bad bad bad bad', rating: 1}}
      expect(response).to redirect_to product_path(product.id)
    end

    it "comment not added - authenticated and have commented on this product - logged_in user, comment not created and user redirected to product's page" do
      sign_in user1
      post :create, params: {product_id: product.id, user_id: user1.id, comment: {body: 'bad bad bad bad', rating: 1}}
      expect(Comment.all.length == 1).to eq(true)
      expect(response).to redirect_to product_path(product.id)
    end

    it "not authenticated - not logged_in user, redirected to login_page" do
      post :create, params: {product_id: product.id, user_id: user1.id, comment: {body: 'bad bad bad bad', rating: 1}}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end
  end
end