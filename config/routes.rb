Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :vote_cancel
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, except: [:index, :show], shallow: true, concerns: :votable do
      member do
        patch 'mark_solution'
      end
    end
  end

  resources :attachments, only: [:destroy]
end
