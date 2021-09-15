Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :voted do
    member do
      put :vote_for
      put :vote_against
      delete :cancel_voting
    end
  end

  resources :questions, concerns: :voted do
    resources :answers, only: %i[create destroy update], concerns: :voted, shallow: true do
      member do
        post :mark_as_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :users, only: :rewards do
    member do
      get :rewards
    end
  end
  
  mount ActionCable.server => '/cable'
end
