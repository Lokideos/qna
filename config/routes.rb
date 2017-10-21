# frozen_string_literal: true

Rails.application.routes.draw do
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

  devise_for :users

  resources :questions, concerns: %i[ratable commentable] do
    resources :answers, concerns: %i[ratable commentable], except: %i[index new show] do
      patch :choose_best, on: :member
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'welcome/index'

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
