class AccountMfaSessionsController < ApplicationController
  before_action :authorize_request

  def create
    @current_account.mfa_secret = params[:mfa_code]
    @current_account.save!
    if @current_account.google_authentic?(params[:mfa_code])
      AccountMfaSession.create(@current_account)
      render json: { message: "Your 2fa was successfull, you can proceed to use the application"}, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def logout
    @current_account.mfa_secret = nil
    @current_account.save!
    AccountMfaSession.destroy
    #Blacklist tokens
  end

  private

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = Jwt.decode(header)
      @current_account = Account.find(@decoded[:account_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end