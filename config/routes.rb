Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions do
    resources :answers, only: %i[create destroy update], shallow: true do
      member do
        post :mark_as_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
