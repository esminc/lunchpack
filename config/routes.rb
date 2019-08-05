Rails.application.routes.draw do
  resources :members
  get 'home/index'
  # devise_for :users
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  root 'lunches#new'
end
