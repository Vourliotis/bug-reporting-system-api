Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[index show create update destroy]
      resources :bugs, only: %i[index show create update destroy]
      resources :ping, only: [:index]
      resources :tokens, only: [:create]
    end
  end
end
