Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "handles#new"
  resource :session do
    get "claim", as: :claim
    post "proof", as: :proof
    get "proof_by_claim", as: :proof_by_claim
  end
  resources :handles, path: "" do
    resources :keys do
      get "claim"
      resource :proof, only: [:create, :show]
    end
  end
end
