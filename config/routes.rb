Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "handles#index"
  resource :session do
    get "claim", as: :claim
    post "proof", as: :proof
  end
  resource :registration
  resources :handles, path: "" do
    post "/on-hn", to: 'proofs#create_identity', as: :hn
    get "/on-hn", to: 'proofs#show_identity'
    get "/on-hn/claim", to: 'proofs#claim', as: :identity_claim
    resources :proofs, only: [:create]
    resources :keys do
      get "claim"
      post "proof", as: :proof
      resource :proof, only: [:create, :show]
    end
  end
end
