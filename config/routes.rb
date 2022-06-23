Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "handles#new"
  resources :handles, path: "" do
    resources :keys do
      get "claim"
      resource :proof, only: [:create, :show]
    end
  end
end
