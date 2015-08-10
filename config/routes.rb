require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :vote_cancel
    end
  end

  resources :questions, concerns: :votable, shallow: true do
    resources :comments, defaults: { commentable: 'questions' }

    resources :subscriptions, only: :create

    resources :answers, except: [:index, :show], concerns: :votable do
      resources :comments, defaults: { commentable: 'answers' }
      patch 'mark_solution', on: :member
    end
  end

  resources :verifications, only: [:new, :create, :show] do
    get 'confirm/:token', on: :member, action: :confirm, as: :confirm
  end

  resources :attachments, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end

      resources :questions, shallow: true do
        resources :answers
      end
    end
  end
end
