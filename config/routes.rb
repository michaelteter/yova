Rails.application.routes.draw do
  get 'portfolio_performances/show'
  mount Sidekiq::Web => '/_sidekiq'

  get 'foo', to: 'admin#foo'

  resources :clients, param: :uuid, only: %i[show] do
    resources :portfolio_performances, param: :period_end, only: %i[show]
  end
end
