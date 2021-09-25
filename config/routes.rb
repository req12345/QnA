Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  namespace :users do
    get '/set_email', to: 'emails#new'
    post '/set_email', to: 'emails#create'
  end

  concern :voted do
    member do
      put :vote_for
      put :vote_against
      delete :cancel_voting
    end
  end

  concern :commented do
    member do
      post :create_comment
    end
  end

  resources :questions, concerns: [:voted, :commented] do
    resources :answers, only: %i[create destroy update], concerns: [:voted, :commented], shallow: true do
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
