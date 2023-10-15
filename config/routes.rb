Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/lectures/import', to: 'lectures#create_lectures', as: 'create_lectures'
      get '/lectures/organize_event', to: 'lectures#organize_event', as: 'organize_event'
      delete '/api/v1/lectures/:id', to: 'lectures#destroy', as: 'destroy_lecture'
      put '/api/v1/lectures/:id', to: 'lectures#update', as: 'update_lecture'

      put 'lectures/update_multiple', to: 'lectures#update_multiple'
      delete 'lectures/destroy_multiple', to: 'lectures#destroy_multiple'
    end
  end

  resources :lectures do
    collection do
      post :import_csv
      delete :destroy_all
    end
  end

  root 'lectures#index'
end