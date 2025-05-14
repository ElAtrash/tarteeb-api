# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "api/v1/products#index"

  namespace :api do
    namespace :v1 do
      post "/auth/login", to: "auth#login"
      post "/auth/register", to: "auth#register"
      get "/auth/me", to: "auth#me"
      get "/navigation", to: "navigation#index"

      resources :products, only: [ :index ] do
        collection do
          post :export
        end
      end
      resources :suppliers
      post "csv_imports/import", to: "csv_imports#import"
    end
  end
end
