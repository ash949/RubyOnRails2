require 'rails_helper'

describe OrdersController, type: :controller do
  context "GET #index:" do
    let(:user1) { User.create!(email: 'test1@test1', password: '123123') }
    let(:user2) { User.create!(email: 'test2@test2', password: '123123') }
    let(:admin) { User.create!(email: 'admin@admin', password: '123123', admin: true) }

    before do
      Order.delete_all
      user1.orders.create!()
      user1.orders.create!()
      user1.orders.create!()
      user1.orders.create!()
      user2.orders.create!()
      user2.orders.create!()
    end

    it 'not authenticated user - not_logged_in user, redirected to login page' do
      get :index, params: {user_id: user1.id}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "not authorized user - non_admin logged_in user access another user's orders, redirected to root page" do
      sign_in user1
      get :index, params: {user_id: user2.id}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it 'orders page showed - authorized user - non_admin logged_in user, redirected to his orders page' do
      sign_in user1
      get :index, params: {user_id: user1.id}
      expect(assigns(:orders).all.length).to eq 4
      expect(response).to render_template('index')
    end

    it 'orders page showed - authorized user - admin logged_in user, redirected to orders page' do
      sign_in admin
      get :index, params: {user_id: admin.id}
      expect(assigns(:orders).length).to eq 6
      expect(response).to render_template('index')
    end
  end

  #==================================================================================================
  context "GET #show:" do
    let(:user1) { User.create!(email: 'test1@test1', password: '123123') }
    let(:user2) { User.create!(email: 'test2@test2', password: '123123') }
    let(:admin) { User.create!(email: 'admin@admin', password: '123123', admin: true) }

    before do
      user1.orders.create!()
      user2.orders.create!()
    end

    it 'not authenticated user - not_logged_in user, redirected to login page' do
      get :show, params: {user_id: user1.id, id: user1.orders.first.id}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it 'no valid IDs provided to select an order - non_admin logged_in user, redirected to root page' do
      sign_in user1
      get :show, params: {user_id: user2.id, id: user1.orders.first.id}
      expect(flash[:alert]).to eq(NO_ID_PROVIDED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it 'order page showed - authorized user - non_admin logged_in user, redirected to his orders page' do
      sign_in user1
      get :show, params: {user_id: user1.id, id: user1.orders.first.id}
      expect(response).to be_ok
      expect(response).to render_template('show')
    end

    it 'no valid id provided even if user is authorized - non_admin logged_in user, redirected to his orders page' do
      sign_in user1
      get :show, params: {user_id: 'test', id: 'test'}
      expect(flash[:alert]).to eq(NO_ID_PROVIDED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it 'order page showed - authorized user - admin logged_in user, redirected to orders page' do
      sign_in admin
      get :show, params: {user_id: user2.id, id: user2.orders.first.id}
      expect(response).to be_ok
      expect(response).to render_template('show')
    end
  end

#==================================================================================================
  context "DELETE #destroy:" do
    
    let(:user1) { User.create!(email: 'test1@test1', password: '123123') }
    let(:user2) { User.create!(email: 'test2@test2', password: '123123') }
    let(:admin) { User.create!(email: 'admin@admin', password: '123123', admin: true) }

    before do
      Order.delete_all
      user1.orders.create!()
      user2.orders.create!()
    end

    it "not authorized - non-admin logged_in user want to delete other's order, redirected to root page" do
      sign_in user1
      delete :destroy, params: {user_id: user2.id, id: user2.orders.first.id}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "order destroyed - authorized - non-admin logged_in user want to delete his order, redirected to orders page" do
      sign_in user1
      delete :destroy, params: {user_id: user1.id, id: user1.orders.first.id}
      expect(Order.all.length).to eq(1)
      expect(response).to redirect_to user_orders_path(user1.id)
    end

    it "not authenticated - not logged_in user, redirected to login page" do
      delete :destroy, params: {user_id: user1.id, id: user1.orders.first.id}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "order destroyed - admin user can delete any order, redirected to orders page" do
      sign_in admin
      delete :destroy, params: {user_id: user1.id, id: user1.orders.first.id}
      expect(Order.all.length).to eq(1)
      expect(response).to redirect_to user_orders_path(user1.id)
    end
  end
end