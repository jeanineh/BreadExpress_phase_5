BreadExpress::Application.routes.draw do

  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items
  resources :users
  resources :sessions
  resources :item_prices
  # Authentication routes



  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy
  get 'search' => 'home#search', as: :search
  get 'cylon' => 'errors#cylon', as: :cylon

  get 'add_to_cart' => 'orders#add_to_cart', as: :add_to_cart
  get 'remove_from_cart' => 'orders#remove_from_cart', as: :remove_from_cart
  get 'menu' => 'orders#menu', as: :menu
  get 'cart' => 'orders#cart', as: :cart
  
  # Set the root url
  root :to => 'home#home'  
  
  # Named routes
  get 'signup' => 'customers#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  patch 'mark_shipped/:id' => 'home#mark_shipped', as: :mark_shipped
  patch 'mark_unshipped/:id' => 'home#mark_unshipped', as: :mark_unshipped
  
  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
