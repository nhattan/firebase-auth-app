Rails.application.routes.draw do
  root to: 'home#index'
  get '/auth/:provider/callback', to: 'home#callback'
  delete '/', to: 'home#signout'
end
