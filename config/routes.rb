Rails.application.routes.draw do
  
  resources :products
  # root 'static_pages#index'
  root to: 'static_page#index'
  
  get 'static_page/index'

  get 'static_page/about'

  get 'static_page/contact'

  
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
