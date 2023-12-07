class AccountMfaSessionController < ApplicationController

  before_action :authorize_request
  before_action :code_validation, only: [:tfa_login]

  def tfa_login
    @current_account.mfa_secret = params[:mfa_code]
    @current_account.save!
    if @current_account.google_authentic?(params[:mfa_code])
      AccountMfaSession.create(@current_account)
      render json: { message: "Your 2fa was successfull, you can proceed to use the application"}, status: :ok
    else
      render json: { error: "Code is not valid or wrong" }, status: :unauthorized
    end
  end

  def logout
    begin
      @current_account.mfa_secret = nil
      @current_account.save!
      AccountMfaSession.destroy
      render json: { message: 'Logged out successfully' }, status: :ok
    rescue => e
      render json: { error: 'Code is not valid or wrong' }, status: 422
    end
    #Blacklist tokens
  end

  private

  def code_validation
    unless params[:mfa_code].present? && params[:mfa_code].length == 6
      render json: { errors: "Invalid code or Code not present" }, status: :unauthorized
    end
  end
end