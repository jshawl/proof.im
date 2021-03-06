# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'handles#index'
  resource :session do
    get 'claim', as: :claim
    post 'proof', as: :proof
  end
  resource :registration
  resources :handles, path: '' do
    post '/on-:service', to: 'proofs#create_identity', as: :identity
    get '/on-:service', to: 'proofs#show_identity'
    get '/on-:service/claim', to: 'proofs#claim', as: :identity_claim
    resources :proofs, only: [:create]
    resources :keys do
      get 'claim'
      post 'proof', as: :proof
      resource :proof, only: %i[create show]
    end
  end
end
