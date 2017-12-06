require 'rails_helper'

describe CommentsController, type: :controller do
  describe 'DELETE #destroy:' do
    let(:product) { FactoryBot.create(:product) }
    let(:commentator) { FactoryBot.build(:user) }
    before do
      skip_confirmation_and_save_users commentator
      product.comments << FactoryBot.create(:comment, user: commentator)
    end

    subject do
      delete :destroy, params: {
        product_id: product.id, id: product.comments.first.id
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

        it ' - comment will be deleted' do
          expect(subject).to redirect_to product_path(product.id)
          expect(product.comments.reload.size).to eq(0)
        end
      end
    end
  end

  # =======================================================================
  describe 'POST #create:' do
    let(:product) { FactoryBot.create(:product) }
    let(:commentator) { FactoryBot.build(:user) }

    before do
      skip_confirmation_and_save_users commentator
      product.comments << FactoryBot.create(:comment, user: commentator)
    end

    subject do
      post :create, params: {
        product_id: product.id, user_id: user.id,
        comment: { body: 'bad bad bad bad', rating: 1 }
      }
    end

    context ' - user is not logged in' do
      let(:user) { FactoryBot.build(:user) }
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
      context " - user hasn't commented on this product" do
        let(:user) { FactoryBot.build(:user) }

        it ' - comment will be added' do
          expect(subject).to redirect_to product_path(product.id)
          expect(product.comments.reload.size == 2).to eq(true)
        end
      end

      context ' - user has already commented on this product' do
        let(:user) { commentator }
        it ' - comment will not be added' do
          expect(subject).to redirect_to product_path(product.id)
          expect(product.comments.reload.size == 1).to eq(true)
        end
      end
    end
  end
end
