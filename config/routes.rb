Rails.application.routes.draw do
  concern :ratable do
    member do
      patch :rate_good
      patch :rate_bad
    end
  end

  devise_for :users
  resources :questions do
    resources :answers, except: [:index, :new, :show] do
      patch :choose_best, on: :member
    end
  end

  resources :questions, concerns: [:ratable]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'welcome/index'

  root to: 'questions#index'
end
