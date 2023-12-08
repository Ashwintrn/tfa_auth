class AccountMfaSessionController < ApplicationController

  before_action :authorize_request
  before_action :code_validation, only: [:tfa_login]

  # POST /auth/tfa_login - mfa_code, access_token
  def tfa_login
    @current_account.mfa_secret = params[:mfa_code]
    @current_account.save!
    if @current_account.google_authentic?(params[:mfa_code])
      AccountMfaSession.create(@current_account)
      render json: { message: "Your 2fa was successfull, You can now proceed to use the application's API"}, status: :ok
    else
      render json: { error: "Invalid Code, Please try again" }, status: :unauthorized
    end
  end

  # DELETE /auth/logout - access_token
  def logout
    begin
      @current_account.logout_actions
      render json: { message: 'Logged out successfully' }, status: :ok
    rescue => e
      render json: { error: 'Something went wrong, Please try again' }, status: 422
    end
  end

  private

  def code_validation
    unless params[:mfa_code].present? && params[:mfa_code].length == 6
      render json: { errors: "Invalid code or Code not present" }, status: :unauthorized
    end
  end
end