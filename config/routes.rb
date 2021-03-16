Rails.application.routes.draw do
  get 'portfolio_performances/show'
  mount Sidekiq::Web => '/_sidekiq'

  get 'foo', to: 'admin#foo'

  namespace :api do
    namespace :admin do
      resources :notifications, param: :id
      resources :client_notifications, param: :id
    end

    namespace :v1 do
      resources :clients, param: :uuid, only: :show do
        resources :client_notifications, param: :uuid, only: :show, path: 'notifications'
        resources :portfolio_performances, param: :period_end, only: :show
      end
    end
  end

  resources :notifications
end
