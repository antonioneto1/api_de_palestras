Rails.application.routes.draw do
  resources :lectures do
    collection do
      get :new
      post :import_csv
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
