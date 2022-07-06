Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "handles#index"
  resources :proofs, only: [:create]
  resource :session do
    get "claim", as: :claim
    post "proof", as: :proof
  end
  resource :registration
  resources :handles, path: "" do
    resources :keys do
      get "claim"
      post "proof", as: :proof
      resource :proof, only: [:create, :show]
    end
    resources :identities do
      get :claim, on: :collection
    end
  end
end
