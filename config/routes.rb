Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  controller :static do
    get :index
  end

  resource :temporary_chat, only: %i[show create]

  resources :ml_models, only: %i[index show] do
    member do
      post :predict
    end
  end

  resources :raw_payloads, only: :index do
    collection do
      get :search
    end
  end

  root "static#index"
end
