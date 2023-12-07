Rails.application.routes.draw do
  resources :accounts, except: [:index, :create]
  post 'account/register', to: 'accounts#create'
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
