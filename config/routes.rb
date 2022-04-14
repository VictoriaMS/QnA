Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do 
    patch :update_voted_up, on: :member
    patch :update_voted_down, on: :member
    resources :answers do
      patch :update_best_answer, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  
  root 'questions#index'
end
