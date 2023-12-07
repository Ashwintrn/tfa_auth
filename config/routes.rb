Rails.application.routes.draw do
  resources :accounts, except: [:index, :create, :show]
  get '/accounts', to: 'accounts#show'
  post 'account/register', to: 'accounts#create'
  post '/auth/init_login', to: 'authentication#init_login'
  post '/auth/tfa_login', to: 'account_mfa_session#tfa_login'
  delete '/auth/logout', to: 'account_mfa_session#logout'
  get '/*a', to: 'application#not_found'
end
