Rails.application.routes.draw do
  resources :projects
  resources :members, except: :show
  get 'home/index'
  # devise_for :users
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  root 'lunches#new'
  resources :lunches, only: :create
end
