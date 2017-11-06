require 'rails_helper'

describe UsersController, type: :controller do
  context "GET #index:" do
    it "renders users index template" do
      get :index
      expect(response).to be_ok
      expect(response).to render_template('index')
    end
  end

  #=======================================================================================
  context "GET #show" do
    let(:user1) { User.create!(email: 'test0@test0', password: '123123') }
    let(:user2) { User.create!(email: 'test1@test1', password: '123123') }
    let(:admin) { User.create!(email: 'test1@test1', password: '123123', admin: true) }

    it "not authorized - non-admin logged_in user, redirected to root page" do
      sign_in user2
      get :show, params: {id: user1.id}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url      
    end

    it "user profile showed - authorized to view his profile - non-admin logged_in user, render his profile page" do
      sign_in user1
      post :show, params: {id: user1.id}
      expect(response).to be_ok
      expect(response).to render_template('show')
    end

    it "no valid user id provided - non-admin logged_in user, redirected to root_url" do
      sign_in user1
      post :show, params: {id: "edit"}
      expect(flash[:alert]).to eq(NO_ID_PROVIDED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "not authenticated - non-admin not logged_in user, redirected to login page" do
      get :show, params: {id: user1.id}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "admin user can update a user, redirected to user's show page" do
      sign_in admin
      get :show, params: {id: user1.id}
      expect(response).to be_ok
      expect(response).to render_template('show')
    end
  end

  #=======================================================================================
  context "GET #new" do
    let(:user1) { User.new() }
    let(:user2) { User.create!(email: 'test1@test1', password: '123123') }
    let(:admin) { User.create!(email: 'test2@test2', password: '123123', admin: true) }

    it "user not authorized - user is logged in and non admin" do
      sign_in user2
      get :new
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "user not authenticated - user is not logged in and non admin" do
      get :new
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "renders users new template if user is logged in and admin" do
      sign_in admin
      get :new
      expect(response).to be_ok
      expect(response).to render_template('new')
    end
  end

  #=======================================================================================
  context "GET #edit" do
    let(:user1) { User.create!(email: 'test0@test0', password: '123123') }
    let(:user2) { User.create!(email: 'test1@test1', password: '123123') }
    let(:admin) { User.create!(email: 'test2@test2', password: '123123', admin: true) }

    it "user not authorized - user is logged in and non admin" do
      sign_in user2
      get :edit, params: {id: user1.id}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "user not authenticated - user is not logged in and non admin" do
      get :edit, params: {id: user1.id}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "renders users edit template if user is logged in and admin" do
      sign_in admin
      get :edit, params: {id: user1.id}
      expect(response).to be_ok
      expect(response).to render_template('edit')
    end
  end
  
  #=======================================================================================
  context "DELETE #destroy:" do
    let(:user1) { User.create!(email: 'test0@test0', password: '123123') }
    let(:user2) { User.create!(email: 'test1@test1', password: '123123') }
    let(:admin) { User.create!(email: 'test2@test2', password: '123123', admin: true) }

    it "not authorized - non-admin logged_in user, redirected to root page" do
      sign_in user2
      delete :destroy, params: {id: user1.id}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "not authenticated - not logged_in user, redirected to login page" do
      delete :destroy, params: {id: user1.id}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "admin user can delete a user, redirected to users page" do
      sign_in admin
      delete :destroy, params: {id: user1.id}
      expect(response).to redirect_to users_path
    end
  end

  #=======================================================================================
  context "POST #create:" do
    let(:user1) { User.new() }
    let(:user2) { User.create!(email: 'test1@test1', password: '123123') }
    let(:admin) { User.create!(email: 'test2@test2', password: '123123', admin: true) }

    it "not authorized - non-admin logged_in user, redirected to root page" do
      sign_in user2
      post :create, params: {user: {first_name: "", last_name: "", email: "test0@test0", password: "123123", password_confirmation: "123123", admin: "0"}}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "not authenticated - non-admin not logged_in user, redirected to login page" do
      post :create, params: {user: {first_name: "", last_name: "", email: "test0@test0", password: "123123", password_confirmation: "123123", admin: "0"}}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "admin user can create a user, redirected to user's show page" do
      sign_in admin
      post :create, params: {user: {first_name: "", last_name: "", email: "test0@test0", password: "123123", password_confirmation: "123123", admin: "0"}}
      expect(response).to redirect_to user_path(User.all.where("email = 'test0@test0'").first.id)
    end
  end

  #=======================================================================================
  context "PATCH #update:" do
    let(:user1) { User.create!(email: 'test0@test0', password: '123123') }
    let(:user2) { User.create!(email: 'test1@test1', password: '123123') }
    let(:admin) { User.create!(email: 'test2@test2', password: '123123', admin: true) }

    it "not authorized - non-admin logged_in user, redirected to root page" do
      sign_in user2
      post :update, params: {id: user1.id, user: {first_name: "test", last_name: "", email: "test0@test0", password: "123123", password_confirmation: "123123", admin: "0"}}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "user updated - authorized to change his first_name, last_name and password- non-admin logged_in user, redirected to root page" do
      sign_in user1
      post :update, params: {id: user1.id, user: {first_name: "test0", last_name: "test0", password: "112233", password_confirmation: "112233"}}
      expect(response).to redirect_to user_path(User.all.where("first_name = 'test0'").first.id)
    end

    it "user not updated - not authorized to change his email and admin flag- non-admin logged_in user, redirected to root page" do
      sign_in user1
      post :update, params: {id: user1.id, user: {first_name: "test", last_name: "", email: "test00@test00", password: "123123", password_confirmation: "123123", admin: "1"}}
      expect(user1.email != 'test00@test00' && user1.admin != true).to eq true
    end

    it "not authenticated - non-admin not logged_in user, redirected to login page" do
      post :update, params: {id: user1.id, user: {first_name: "test", last_name: "", email: "test0@test0", password: "123123", password_confirmation: "123123", admin: "0"}}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "admin user can update a user, redirected to user's show page" do
      sign_in admin
      post :update, params: {id: user1.id, user: {first_name: "test", last_name: "", email: "test00@test00", password: "123123", password_confirmation: "123123", admin: "0"}}
      expect(response).to redirect_to user_path(User.all.where("email = 'test00@test00'").first.id)
    end
  end
end