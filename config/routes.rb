# frozen_string_literal: true

Rails.application.routes.draw do
  concern :ratable do
    member do
      patch :rate_good
      patch :rate_bad
      patch :cancel_rate
    end
  end

  devise_for :users
  resources :questions do
    resources :answers, except: %i[index new show] do
      patch :choose_best, on: :member
    end
    resources :answers, concerns: [:ratable]
  end

  resources :questions, concerns: [:ratable]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'welcome/index'

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
