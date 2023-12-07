class AuthenticationController < ApplicationController
  before_action :authorize_session, except: :init_login

  # POST /auth/login
  def init_login
    @account = Account.find_by_email(params[:email])
    if @account&.authenticate(params[:password])
      token = Jwt.encode(account_id: @account.id)
      time = Time.now + 45.minutes.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M")}, status: :ok
    else
      render json: { error: 'Unable to authorize, Please try again' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end