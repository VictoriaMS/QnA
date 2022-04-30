Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

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
  end

  resources :attachments, only: [:destroy]
  
  root 'questions#index'

  mount ActionCable.server => '/cable'
end
