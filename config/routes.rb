Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'tokens/create'
    end
  end
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[index show create update destroy]
      resources :ping, only: [:index]
      resources :tokens, only: [:create]
    end
  end
end
