Rails.application.routes.draw do
  resources :prompts
  resources :activities
  resources :favor_items
  get 'admin' => 'admin#index'

  controller :activities do
    get 'activity_show' => :show_activity
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :orders
  resources :line_items
  resources :carts
  root 'store#index', as: 'store_index'
  resources :products
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
