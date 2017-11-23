require 'rails_helper'

describe OrdersController, type: :controller do
  before(:context) do
    FactoryBot.create(:status, status_type: 'active')
    FactoryBot.create(:status, status_type: 'canceled')
    FactoryBot.create(:status, status_type: 'delivered')
  end

  context 'GET #index:' do
    let(:user1) { FactoryBot.build(:user) }
    let(:user2) { FactoryBot.build(:user) }
    let(:admin) { FactoryBot.build(:admin) }

    before do
      user1.skip_confirmation!
      user1.save
      user2.skip_confirmation!
      user2.save
      admin.skip_confirmation!
      admin.save
      Order.delete_all
      user1.orders << FactoryBot.build_list(:order, 4, user: nil)
      user2.orders << FactoryBot.build_list(:order, 2, user: nil)
    end

    it 'not authenticated user - not_logged_in user,
        redirected to login page' do
      get :index, params: { user_id: user1.id }
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "not authorized user
        non_admin logged_in user access another user's orders,
        redirected to root page" do
      sign_in user1
      get :index, params: { user_id: user2.id }
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it 'orders page showed (5 orders if do not have active order)
        authorized user - non_admin logged_in user,
        redirected to his orders page' do
      sign_in user1
      get :index, params: { user_id: user1.id }
      expect(assigns(:orders).length).to eq 5
      expect(response).to render_template('index')
    end

    it 'orders page showed (4 orders if he already have active order)
        authorized user - non_admin logged_in user,
        redirected to his orders page' do
      sign_in user1
      user1.orders.each do |order|
        order.status = Status.canceled
      end
      user1.orders.last.status = Status.active
      user1.orders.last.save
      get :index, params: { user_id: user1.id }
      expect(assigns(:orders).length).to eq 4
      expect(response).to render_template('index')
    end

    it 'orders page showed
        authorized user - admin logged_in user,
        redirected to orders page' do
      sign_in admin
      get :index, params: { user_id: admin.id }
      expect(assigns(:orders).length).to eq 6
      expect(response).to render_template('index')
    end
  end

  # =========================================================================
  context 'GET #show:' do
    let(:user1) { FactoryBot.build(:user) }
    let(:user2) { FactoryBot.build(:user) }
    let(:admin) { FactoryBot.build(:admin) }

    before do
      user1.skip_confirmation!
      user1.save
      user2.skip_confirmation!
      user2.save
      admin.skip_confirmation!
      admin.save
      user1.orders << FactoryBot.build(:order, user: nil)
      user2.orders << FactoryBot.build(:order, user: nil)
    end

    it 'not authenticated user - not_logged_in user,
        redirected to login page' do
      get :show, params: { user_id: user1.id, id: user1.orders.first.id }
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "not authorized user
        non_admin logged_in user trying to access someone's else order,
        redirected to root page" do
      sign_in user1
      get :show, params: { user_id: user2.id, id: user1.orders.first.id }
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it 'order page showed
        authorized user - non_admin logged_in user,
        redirected to his orders page' do
      sign_in user1
      get :show, params: { user_id: user1.id, id: user1.orders.first.id }
      expect(response).to be_ok
      expect(response).to render_template('show')
    end

    it 'no valid id provided even if user is authorized
        non_admin logged_in user,
        redirected to his orders page' do
      sign_in user1
      get :show, params: { user_id: 'test', id: 'test' }
      expect(flash[:alert]).to eq(NO_ID_PROVIDED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it 'order page showed
        authorized user - admin logged_in user,
        redirected to orders page' do
      sign_in admin
      get :show, params: { user_id: user2.id, id: user2.orders.first.id }
      expect(response).to be_ok
      expect(response).to render_template('show')
    end
  end

  # =========================================================================
  context 'DELETE #destroy:' do
    let(:user1) { FactoryBot.build(:user) }
    let(:user2) { FactoryBot.build(:user) }
    let(:admin) { FactoryBot.build(:admin) }

    before do
      user1.skip_confirmation!
      user1.save
      user2.skip_confirmation!
      user2.save
      admin.skip_confirmation!
      admin.save
      Order.delete_all
      user1.orders << FactoryBot.build(:order, user: nil)
      user1.orders << FactoryBot.build(:order, user: nil)
      user2.orders << FactoryBot.build(:order, user: nil)
      user1.orders.first.status = Status.canceled
      user1.orders.first.save
      user1.orders.last.status = Status.active
      user1.orders.last.save
    end

    it "not authorized - non-admin logged_in user want to delete other's order,
        redirected to root page" do
      sign_in user1
      delete :destroy, params: { user_id: user2.id, id: user2.orders.first.id }
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it 'not authorized - non-admin logged_in user want to delete his order,
        redirected to root page' do
      sign_in user1
      delete :destroy, params: { user_id: user1.id, id: user1.orders.first.id }
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it 'not authenticated - not logged_in user,
        redirected to login page' do
      delete :destroy, params: { user_id: user1.id, id: user1.orders.first.id }
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it 'non active order destroyed
        admin user can delete any order,
        redirected to orders page' do
      sign_in admin
      delete :destroy, params: { user_id: user1.id, id: user1.orders.first.id }
      expect(user1.orders.reload.size).to eq(1)
      expect(response).to redirect_to user_orders_path(user1.id)
    end
  end
end
