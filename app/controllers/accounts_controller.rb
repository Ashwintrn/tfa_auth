class AccountsController < ApplicationController
  before_action :authorize_session, except: %i[create]
  before_action :find_account, except: %i[create]

  UPDATABLE_ATTR = ["name", "password", "tfa_status"]
  SENSITIVE_DATA = [:password_digest, :google_secret, :mfa_secret]

  # access_token needed for all operations except create
  
  # GET /accounts/
  def show
    render json: @account.as_json(except: SENSITIVE_DATA), status: :ok
  end

  # POST /account/register - email, password and confirmation
  def create
    @account = Account.new(account_params)
    if @account.save
      render json: @account.as_json(except: SENSITIVE_DATA), status: :created
    else
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /accounts/
  def update
    account_param = account_params.select { |key, _v| UPDATABLE_ATTR.include?(key.to_s)}
    if @account.update(account_param)
      render json: { message: "Account Settings has been updated successfully"}, status: :ok
    else
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/
  # def destroy NOT IMPLEMETED
  #   @account.destroy
  # end

  private

  def find_account
    @account = @current_account
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Account not found' }, status: :not_found
  end

  def account_params
    params.permit(
      :name, :email, :password, :password_confirmation, :tfa_status
    )
  end
end
