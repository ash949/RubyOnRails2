require 'rails_helper'


describe ProductsController, type: :controller do
  context "GET #index:" do
    it "renders products index template" do
      get :index
      expect(response).to be_ok
      expect(response).to render_template('index')
    end
  end

  #=======================================================================================
  context "GET #show" do
    let(:product) { FactoryBot.create(:product) }
    it "renders products show template" do
      get :show, params: { id: product.id }
      expect(response).to be_ok
      expect(response).to render_template('show')
    end

    it "renders products show template" do
      get :show, params: {id: "edit"}
      expect(flash[:alert]).to eq(NO_ID_PROVIDED_MESSAGE)
      expect(response).to redirect_to root_url
    end
  end

  #=======================================================================================
  context "GET #new" do
    let(:product) { FactoryBot.build(:product) }
    let(:user) { FactoryBot.create(:user) }
    let(:admin) { FactoryBot.create(:admin) }

    it "user not authorized - user is not logged in and non admin" do
      get :new
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)      
      expect(response).to redirect_to new_user_session_path
    end

    it "user not authorized - user is logged in and non admin" do
      sign_in user
      get :new
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "new user form showed - renders products new template if user is logged in and admin" do
      sign_in admin
      get :new
      expect(response).to be_ok
      expect(response).to render_template('new')
    end
  end

  #=======================================================================================
  context "GET #edit" do
    let(:product) { FactoryBot.create(:product) }
    let(:user) { FactoryBot.create(:user) }
    let(:admin) { FactoryBot.create(:admin) }

    it "user not authorized - user is logged in and non admin" do
      sign_in user
      get :edit, params: {id: product.id}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)      
      expect(response).to redirect_to root_url
    end

    it "user not authenticated - user is not logged in" do
      get :edit, params: {id: product.id}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "renders products edit template if user is logged in and admin" do
      sign_in admin
      get :edit, params: {id: product.id}
      expect(response).to be_ok
      expect(response).to render_template('edit')
    end
  end
  
  #=======================================================================================
  context "DELETE #destroy:" do
    let(:product) { FactoryBot.create(:product) }
    let(:user) { FactoryBot.create(:user) }
    let(:admin) { FactoryBot.create(:admin) }

    it "not authorized - non-admin logged_in user can't delete a product, redirected to root page" do
      sign_in user
      delete :destroy, params: {id: product.id}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "not authenticated - non-admin not logged_in user, redirected to login page" do
      delete :destroy, params: {id: product.id}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "admin user can delete a product, redirected to products page" do
      sign_in admin
      delete :destroy, params: {id: product.id}
      expect(Product.all.size).to eq(0)
      expect(response).to redirect_to products_path
    end
  end

  #=======================================================================================
  context "POST #create:" do
    let(:product) { Product.new() }
    let(:user) { FactoryBot.create(:user) }
    let(:admin) { FactoryBot.create(:admin) }

    it "not authorized - non-admin logged_in user, redirected to root page" do
      sign_in user
      post :create, params: {product: {name: 'Laptop 1', price_in_cents: 500, image_url: "", description: "", features: "", showcase_images: ""}}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "not authenticated - non-admin not logged_in user, redirected to login page" do
      post :create, params: {product: {name: 'Laptop 1', price_in_cents: 500, image_url: "", description: "", features: "", showcase_images: ""}}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "admin user can create a product, redirected to products page" do
      sign_in admin
      post :create, params: {product: {name: 'Laptop 1', price_in_cents: 500, image_url: "", description: "", features: "", showcase_images: ""}}
      expect(Product.all.reload.size == 1 && Product.all.first.name == 'Laptop 1').to eq(true)
      expect(response).to redirect_to product_path(Product.last.id)
    end
  end

  #=======================================================================================
  context "PATCH #update:" do
    let(:product) { FactoryBot.create(:product) }
    let(:user) { FactoryBot.create(:user) }
    let(:admin) { FactoryBot.create(:admin) }

    it "not authorized - non-admin logged_in user, redirected to root page" do
      sign_in user
      patch :update, params: {id: product.id, product: {name: 'CHEANGED Laptop 1', price_in_cents: 500, image_url: "", description: "", features: "", showcase_images: ""}}
      expect(flash[:alert]).to eq(NOT_AUTHORIZED_MESSAGE)
      expect(response).to redirect_to root_url
    end

    it "not authenticated - non-admin not logged_in user, redirected to login page" do
      patch :update, params: {id: product.id, product: {name: 'CHEANGED Laptop 1', price_in_cents: 500, image_url: "", description: "", features: "", showcase_images: ""}}
      expect(flash[:alert]).to eq(NOT_AUTHENTICATED_MESSAGE)
      expect(response).to redirect_to new_user_session_path
    end

    it "admin user can update a product, redirected to products page" do
      sign_in admin
      patch :update, params: {id: product.id, product: {name: 'CHEANGED Laptop 1', price_in_cents: 500, image_url: "", description: "", features: "", showcase_images: ""}}
      expect(Product.all.reload.size == 1 && Product.all.first.name == 'CHEANGED Laptop 1').to eq(true)
      expect(response).to redirect_to product_path(product.id)
    end
  end
end