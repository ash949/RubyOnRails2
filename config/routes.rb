Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup'}, controllers: { registrations: "user_registrations" }
  
  resources :products do
    resources :comments
  end

  resources :users do
    resources :comments
  end

  resources :users do
    resources :orders do 
      resources :products
    end
  end

  post 'users/:user_id/orders/:order_id/products/:id', to: 'products#add_to_cart'
  
  #payments
  post 'payments/create', to: 'payments#create'

  
  #root
  root 'static_pages#landing_page'
  

  # static_pages routes
  get 'static_pages/', to: 'static_pages#index' 

  get 'static_pages/index'

  get 'static_pages/about'

  get 'static_pages/contact', to: 'static_pages#contact'

  post 'static_pages/thank_you', to: 'static_pages#thank_you'

  get 'branches', to: 'branches#get_coordinates'
  #----------------------------------------------------------------

  # orders routes
  # delete 'orders/:id/:product_id', to: 'orders#remove_product', as: 'remove_product_from_order'
  #----------------------------------------------------------------

  
  get 'static_pages/page_404', to: 'static_pages#page_404'

  #I want to redirect every not specified route into some page ()
  match "*path", to: 'static_pages#no_route', via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
