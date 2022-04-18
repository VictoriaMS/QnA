Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :votable do
    patch :voted_up, on: :member 
    patch :voted_down, on: :member
  end

  resources :questions, concerns: :votable do 
    resources :answers, concerns: :votable do
      patch :update_best_answer, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  
  root 'questions#index'
end
