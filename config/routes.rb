Rails.application.routes.draw do
  resources :accounts, except: [:index, :create]
  post 'account/register', to: 'accounts#create'
  post '/auth/init_login', to: 'authentication#init_login'
  get '/*a', to: 'application#not_found'
end
