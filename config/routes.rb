Rails.application.routes.draw do
  mount Sidekiq::Web => '/_sidekiq'

  get 'foo', to: 'admin#foo'

  namespace :api do
    namespace :admin do
      resources :notifications, param: :id
    end

    namespace :v1 do
      post 'authenticate', to: 'authentication#create'

      resources :clients, param: :uuid, only: :show do
        resources :notifications, param: :uuid, only: %i[index show]
        resource :portfolios, only: :show, path: 'portfolio'
      end
    end
  end

end
