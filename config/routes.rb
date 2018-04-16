# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  concern :ratable do
    member do
      patch :rate_good
      patch :rate_bad
      patch :cancel_rate
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', confirmations: 'confirmations' }

  resources :questions, concerns: %i[ratable commentable] do
    resources :answers, concerns: %i[ratable commentable], except: %i[index new show] do
      patch :choose_best, on: :member
    end
  end

  resource :email_oauth_assigner do
    get :find_email, on: :member
    post :check_email, on: :member
    post :assign_oauth_authorization, on: :member
  end

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'welcome/index'

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
