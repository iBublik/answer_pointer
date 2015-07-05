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

  resources :questions, concerns: [:votable], shallow: true do
    resources :comments, defaults: { commentable: 'questions' }

    resources :answers, except: [:index, :show], concerns: [:votable] do
      resources :comments, defaults: { commentable: 'answers' }
      member do
        patch 'mark_solution'
      end
    end
  end

  resources :attachments, only: [:destroy]
end
