Rails.application.routes.draw do
  root 'lunches#new'
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  resources :lunches, only: %i(index create destroy)
  resources :members, except: :show
  resources :projects, expect: :show
end
