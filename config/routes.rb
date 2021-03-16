Rails.application.routes.draw do
  get 'portfolio_performances/show'
  mount Sidekiq::Web => '/_sidekiq'

  get 'foo', to: 'admin#foo'

  resources :clients, param: :uuid, only: :show do
    resources :client_notifications, param: :uuid, only: :show, path: 'notifications'
    resources :portfolio_performances, param: :period_end, only: :show
  end

  resources :notifications
end
