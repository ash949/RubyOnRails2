require 'rails_helper'

describe ProductsController, type: :controller do
  before(:context) do
    FactoryBot.create(:status, status_type: 'active')
    FactoryBot.create(:status, status_type: 'canceled')
    FactoryBot.create(:status, status_type: 'delivered')
  end

  describe 'GET #index:' do
    it 'renders products index template' do
      get :index
      expect(response).to be_ok
      expect(response).to render_template('index')
    end
  end

  # =======================================================================
  describe 'GET #show' do
    let(:product) { FactoryBot.create(:product) }
    subject { get :show, params: { id: id } }

    context ' - product id is provided and exists' do
      let(:id) { product.id }
      it ' - renders products show template' do
        expect(subject).to be_ok
        expect(subject).to render_template('show')
      end
    end

    context ' - product id is not provided or it doesn"t exist' do
      let(:id) { 'edit' }
      it ' - renders products show template' do
        expect(subject).to redirect_to root_url
        expect(flash[:alert]).to eq(NO_ID_PROVIDED_MESSAGE)
      end
    end
  end

  # =======================================================================
  describe 'GET #new' do
    let(:product) { FactoryBot.build(:product) }
    subject { get :new }

    context ' - user is not logged in' do
      it ' - renders login page and display not authenticated message' do
        expect(subject).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      end
    end

    context ' - user is logged in' do
      before do
        skip_confirmation_and_save_users user
        sign_in user
      end

      context ' - user is not admin' do
        let(:user) { FactoryBot.build(:user) }
        it ' - redirect to root page and display not authorized message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
        end
      end

      context ' - user is admin' do
        let(:user) { FactoryBot.build(:admin) }
        it ' - render new product page' do
          expect(subject).to be_ok
          expect(subject).to render_template('new')
        end
      end
    end
  end

  # =======================================================================
  describe 'GET #edit' do
    let(:product) { FactoryBot.create(:product) }
    subject { get :edit, params: { id: product.id } }

    context ' - user is not logged in' do
      it ' - renders login page and display not authenticated user message' do
        expect(subject).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      end
    end

    context ' - user is logged in' do
      before do
        skip_confirmation_and_save_users user
        sign_in user
      end

      context ' - user is not admin' do
        let(:user) { FactoryBot.build(:user) }
        it ' - renders root page and displays not authorized user message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
        end
      end

      context ' - user is admin' do
        let(:user) { FactoryBot.build(:admin) }
        it ' - renders edit product page' do
          expect(subject).to be_ok
          expect(subject).to render_template('edit')
        end
      end
    end
  end

  # =======================================================================
  describe 'DELETE #destroy:' do
    let(:product) { FactoryBot.create(:product) }
    subject { delete :destroy, params: { id: product.id } }

    context ' - user is not logged in' do
      it ' - renders login page and displays not authenticated user message' do
        expect(subject).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      end
    end

    context ' - user is logged in' do
      before do
        skip_confirmation_and_save_users(user)
        sign_in user
      end

      context ' - user is not admin' do
        let(:user) { FactoryBot.build(:user) }

        it ' - renders root page and displays not authorized user message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
        end
      end

      context ' - user is admin' do
        let(:user) { FactoryBot.build(:admin) }

        it ' - product will be deleted' do
          expect(subject).to redirect_to products_path
          expect(Product.all.size).to eq(0)
        end
      end
    end
  end

  # =======================================================================
  describe 'POST #create:' do
    let(:product) { Product.new }
    subject do
      post :create, params: {
        product: {
          name: 'Laptop 1', price_in_cents: 500, image_url: '',
          description: '', features: '', showcase_images: ''
        }
      }
    end

    context ' - user is not logged in' do
      it ' - renders login page and displays not authenticated user message' do
        expect(subject).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      end
    end

    context ' - user is logged in' do
      before do
        skip_confirmation_and_save_users user
        sign_in user
      end

      context ' - user is not admin' do
        let(:user) { FactoryBot.build(:user) }
        it ' - renders root page and displays not authorized user message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
        end
      end

      context ' - user is admin' do
        let(:user) { FactoryBot.build(:admin) }

        it ' - products will be created' do
          expect(subject).to redirect_to product_path(Product.last.id)
          expect(
            Product.all.reload.size == 1 && Product.all.first.name == 'Laptop 1'
          ).to eq(true)
        end
      end
    end
  end

  # =======================================================================
  describe 'PATCH #update:' do
    let(:product) { FactoryBot.create(:product) }
    subject do
      patch :update, params: {
        id: product.id, product: {
          name: 'CHEANGED Laptop 1', price_in_cents: 500, image_url: '',
          description: '', features: '', showcase_images: ''
        }
      }
    end

    context ' - user is not logged in' do
      it ' - renders login page and displays not authenticated user message' do
        expect(subject).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      end
    end

    context ' - user is logged in' do
      before do
        skip_confirmation_and_save_users user
        sign_in user
      end

      context ' - user is not admin' do
        let(:user) { FactoryBot.build(:user) }
        it ' - renders root page and displays not authorized user message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
        end
      end

      context ' - user is admin' do
        let(:user) { FactoryBot.build(:admin) }

        it ' - products will be updated' do
          expect(subject).to redirect_to product_path(product.id)
          expect(
            Product.all.reload.size == 1 &&
            Product.all.first.name == 'CHEANGED Laptop 1'
          ).to eq(true)
        end
      end
    end
  end
end
