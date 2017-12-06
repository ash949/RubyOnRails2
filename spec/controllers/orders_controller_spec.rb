require 'rails_helper'

describe OrdersController, type: :controller do
  before(:context) do
    FactoryBot.create(:status, status_type: 'active')
    FactoryBot.create(:status, status_type: 'canceled')
    FactoryBot.create(:status, status_type: 'delivered')
  end

  describe 'GET #index:' do
    let(:user) { FactoryBot.build(:user) }
    let(:subject_user) { user }
    let(:another_user) { FactoryBot.build(:user) }
    subject { get :index, params: { user_id: subject_user.id } }

    before do
      skip_confirmation_and_save_users user, another_user
      user.orders << FactoryBot.build_list(:order, 4, user: nil)
      another_user.orders << FactoryBot.build_list(:order, 2, user: nil)
    end

    context ' - user is not logged in' do
      it ' - renders login page and displays not authenticated user message' do
        expect(subject).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      end
    end

    context ' - user is logged in' do
      before do
        sign_in user
      end

      context " - user tries viewing another's orders" do
        let(:subject_user) { another_user }
        it ' - renders root page and displays not authorized user message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
        end
      end

      context ' - user tries viewing his orders' do
        context ' - there is already an active order' do
          before do
            user.orders.each do |order|
              order.status = Status.canceled
            end
            user.orders.last.status = Status.active
            user.orders.last.save
          end
          it '' do
            expect(subject).to render_template('index')
            expect(assigns(:orders).length).to eq 4
          end
        end

        context ' - there is no active order' do
          it '' do
            expect(subject).to render_template('index')
            expect(assigns(:orders).length).to eq 5
          end
        end
      end

      context ' - user is admin' do
        let(:user) { FactoryBot.build(:admin) }
        it ' - renders orders page and will contain 6 orders total' do
          expect(subject).to render_template('index')
          expect(assigns(:orders).length).to eq 6
        end
      end
    end
  end

  # =========================================================================
  describe 'GET #show:' do
    let(:user) { FactoryBot.build(:user) }
    let(:subject_user) { user }
    let(:subject_order_id) { subject_user.orders.first.id }
    let(:another_user) { FactoryBot.build(:user) }
    subject do
      get :show, params: {
        user_id: subject_user.id, id: subject_order_id
      }
    end

    before do
      skip_confirmation_and_save_users user, another_user
      user.orders << FactoryBot.build(:order, user: nil)
      another_user.orders << FactoryBot.build(:order, user: nil)
    end

    context ' - user is not logged in' do
      it ' - renders login page and displays not authenticated user message' do
        expect(subject).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      end
    end

    context ' - user is logged in' do
      before do
        sign_in user
      end

      context " - user tries viewing another's order" do
        let(:subject_user) { another_user }
        it ' - renders root page and displays not authorized user message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
        end
      end

      context ' - user tries viewing his order' do
        it ' - displays order page' do
          expect(subject).to be_ok
          expect(subject).to render_template('show')
        end
      end

      context " - access an invalid order id or doesn't exist" do
        let(:subject_order_id) { 'bla' }
        it ' - renders root page and displays invalid order_id message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NO_ID_PROVIDED_MESSAGE)
        end
      end

      context " - user is admin and want to access another's order" do
        let(:user) { FactoryBot.build(:admin) }
        let(:subject_user) { another_user }
        it ' - renders order page of the other user' do
          expect(subject).to be_ok
          expect(subject).to render_template('show')
        end
      end
    end
  end

  # =========================================================================
  describe 'DELETE #destroy:' do
    let(:user) { FactoryBot.build(:user) }
    let(:subject_user) { user }
    subject do
      delete :destroy, params: {
        user_id: subject_user.id, id: subject_user.orders.first.id
      }
    end

    before do
      skip_confirmation_and_save_users user
      user.orders << FactoryBot.build_list(:order, 2, user: nil)
      user.orders.first.status = Status.canceled
      user.orders.first.save
      user.orders.last.status = Status.active
      user.orders.last.save
    end

    context ' - user is not logged in' do
      it ' - renders login page and displays not authenticated user message' do
        expect(subject).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      end
    end

    context ' - user is logged in' do
      before do
        sign_in user
      end

      context ' - user is not admin' do
        it ' - renders root page and displays not authorized message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
        end
      end

      context ' - user is admin' do
        let(:user) { FactoryBot.build(:admin) }
        it ' - order will be deleted' do
          expect(subject).to redirect_to user_orders_path(user.id)
          expect(user.orders.reload.size).to eq(1)
        end
      end
    end
  end
end
