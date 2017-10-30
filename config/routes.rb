Rails.application.routes.draw do
  
  resources :products

  resources :orders, only: [:index, :show, :create, :destroy]
  
  # old root
  # root to: 'static_pages#landing_page'

  # new root
  root 'products#index'

  # remove if root
  get 'static_pages/landing_page', to: 'static_pages#landing_page'
  
  get 'static_pages/', to: 'static_pages#index' 

  get 'static_pages/index'

  get 'static_pages/about'

  get 'static_pages/contact', to: 'static_pages#contact'

  get 'branches', to: 'branches#get_coordinates'

  
  get 'static_pages/page_404', to: 'static_pages#page_404'

  #I want to redirect every not specified route into some page ()
  match "*path", to: 'static_pages#no_route', via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
