Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true
  end

  resources :answers do
    member do
      patch 'mark_solution'
    end
  end

  resources :attachments, only: [:destroy]
end
