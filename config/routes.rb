Rails.application.routes.draw do
  
  resources :products

  resources :orders, only: [:index, :show, :create, :destroy]
  
  root to: 'static_pages#landing_page'
  
  get 'static_pages/index'

  get 'static_pages/about'

  get 'static_pages/contact', to: 'static_pages#contact'

  get 'branches', to: 'branches#get_coordinates'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
