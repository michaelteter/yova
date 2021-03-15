Rails.application.routes.draw do
  mount Sidekiq::Web => '/_sidekiq'

  get 'foo', to: 'admin#foo'
end
