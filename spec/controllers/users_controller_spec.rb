require 'rails_helper'

describe UsersController, type: :controller do
  describe 'GET #index:' do
    it 'renders users index template' do
      get :index
      expect(response).to be_ok
      expect(response).to render_template('index')
    end
  end

  # =======================================================================
  describe 'GET #show' do
    let(:user) { FactoryBot.build(:user) }
    let(:another_user) { FactoryBot.build(:user) }
    let(:subject_user_id) { user.id }
    let(:admin) { FactoryBot.build(:admin) }
    subject { post :show, params: { id: subject_user_id } }

    before do
      skip_confirmation_and_save_users user, another_user
    end

    context ' - user is not logged in' do
      it ' - renders login page and display not authenticated user message' do
        expect(subject).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      end
    end

    context ' - user is logged in' do
      before do
        sign_in user
      end

      context ' - user is trying to view his profile' do
        it ' - user profile is displayed' do
          expect(subject).to be_ok
          expect(subject).to render_template('show')
        end
      end

      context " - user is trying to view another's profile" do
        let(:subject_user_id) { another_user.id }
        it ' - renders root page and displays not authorized user message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
        end
      end

      context " - user is admin and is trying to view another's profile" do
        let(:user) { FactoryBot.build(:admin) }
        let(:subject_user_id) { another_user.id }
        it ' - user profile is displayed' do
          expect(subject).to be_ok
          expect(subject).to render_template('show')
        end
      end

      context ' - no valid user_id provided' do
        let(:subject_user_id) { 'asdasd' }
        it ' - renders root page and displays invalid id message' do
          expect(subject).to redirect_to root_url
          expect(flash[:alert]).to eq(NO_ID_PROVIDED_MESSAGE)
        end
      end
    end
  end

  # =======================================================================
  describe 'GET #new' do
    subject { get :new }

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
        it ' - renders new user page' do
          expect(subject).to be_ok
          expect(subject).to render_template('new')
        end
      end
    end
  end

  # =======================================================================
  describe 'GET #edit: ' do
    let(:subject_user) { FactoryBot.build(:user) }
    subject { get :edit, params: { id: subject_user.id } }

    before { skip_confirmation_and_save_users subject_user }

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
        it ' - renders edit user page' do
          expect(subject).to be_ok
          expect(subject).to render_template('edit')
        end
      end
    end
  end

  # =======================================================================
  describe 'DELETE #destroy:' do
    let(:subject_user) { FactoryBot.build(:user) }
    subject { delete :destroy, params: { id: subject_user.id } }

    before { skip_confirmation_and_save_users subject_user }

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
        it ' - user will be deleted' do
          expect(subject).to redirect_to users_path
          expect(User.all.reload.where("id = #{subject_user.id}").size).to eq(0)
        end
      end
    end
  end

  # =======================================================================
  describe 'POST #create:' do
    subject do
      post :create, params: {
        user: {
          first_name: '', last_name: '', email: 'test_inserted@test',
          password: '123123', password_confirmation: '123123', admin: '0'
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
        it ' - user will be created' do
          expect(
            subject
          ).to redirect_to user_path(
            User.all.where("email = 'test_inserted@test'").first.id
          )
          expect(
            User.all.reload.find(
              assigns(:user).id
            ).email == 'test_inserted@test'
          ).to eq(true)
        end
      end
    end
  end

  # =======================================================================
  describe 'PATCH #update:' do
    let(:user) { FactoryBot.build(:user) }
    let(:another_user) { FactoryBot.build(:user) }
    let(:subject_user) { user }

    subject do
      patch :update, params: {
        id: subject_user.id,
        user: {
          first_name: 'testing_f', last_name: 'testing_l',
          password: '112233', password_confirmation: '112233'
        }
      }
    end

    before { skip_confirmation_and_save_users user, another_user }

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
        context ' - user trying to edit his profile (name and password)' do
          it ' - renders user profile page
              and first_name and last_name and password will be upadated' do
            expect(
              subject
            ).to redirect_to user_path(
              User.all.where("first_name = 'testing_f'").first.id
            )
            expect(
              User.all.find(subject_user.id).first_name == 'testing_f' &&
              User.all.find(subject_user.id).last_name == 'testing_l'
            ).to eq(true)
          end
        end

        context ' - user trying to edit his profile (email and admin flag)' do
          subject do
            patch :update, params: {
              id: subject_user.id,
              user: { email: 'test00@test00', admin: '1' }
            }
          end
          it ' - email and admin flag will not be updated' do
            expect(
              subject_user.email != 'test00@test00' &&
              subject_user.admin != true
            ).to eq true
          end
        end

        context " - user trying to edit another's profile" do
          let(:subject_user) { another_user }
          it ' - renders root page and displays not authorized user message' do
            expect(subject).to redirect_to root_url
            expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
          end
        end
      end

      context ' - user is admin' do
        let(:user) { FactoryBot.build(:admin) }
        let(:subject_user) { another_user }
        subject do
          patch :update, params: {
            id: subject_user.id,
            user: {
              first_name: 'testing_f', last_name: 'testing_l',
              email: 'test00@test00', password: '111111',
              password_confirmation: '111111', admin: '1'
            }
          }
        end
        it ' - user will be updated' do
          expect(subject).to redirect_to user_path(subject_user.id)
          expect(
            User.all.find(subject_user.id).first_name == 'testing_f' &&
            User.all.find(subject_user.id).last_name == 'testing_l' &&
            User.all.find(subject_user.id).email == 'test00@test00' &&
            User.all.find(subject_user.id).admin == true
          ).to eq(true)
        end
      end
    end
  end
end
