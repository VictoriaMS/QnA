Rails.application.routes.draw do
  require 'sidekiq/web'
  
  mount Sidekiq::Web => '/sedikeq'

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' } 

  devise_scope :user do
    post :set_email, controller: :omniauth_callbacks, as: :set_user_email
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :search, only: :show

  concern :votable do
    patch :voted_up, on: :member 
    patch :voted_down, on: :member
    delete :revote, on: :member
  end

  concern :commentable do 
    resources :comments, shallow: true
  end

  resources :comments, only: [:create]

  resources :questions do 
    concerns :votable, :commentable

    resources :answers, shallow: true do
      concerns :votable, :commentable
      patch :update_best_answer, on: :member
    end

    resources :question_subscribes, only: [:create, :destroy], shallow: true
  end

  resources :attachments, only: [:destroy]
  
  root 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions do 
        resources :answers, shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
