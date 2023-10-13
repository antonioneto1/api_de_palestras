Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/lecture/import', to: 'lectures#create_lectures', as: 'create_lectures'
      get '/lecture/organize_event', to: 'lectures#organize_event', as: 'organize_event'
    end
  end

  resources :lectures do
    collection do
      get :import
      post :import_csv
    end
    member do
      delete :destroy
    end
  end

  root 'lectures#index'
end