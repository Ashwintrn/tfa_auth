class AccountsController < ApplicationController
  before_action :authorize_session, except: %i[create]
  before_action :find_account, except: %i[create]

  UPDATABLE_ATTR = ["name", "password", "tfa_status"]

  # GET /accounts/
  def show
    render json: @account.as_json(except: :password_digest), status: :ok
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)
    if @account.save
      begin
        @account.set_google_secret
      rescue => e
        render json: { errors: "Accoutn created but unable to set google key. Please contact your operator" }, status: :unprocessable_entity
      end
      render json: @account, status: :created
    else
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /accounts/
  def update
    account_param = account_params.select { |key, _v| UPDATABLE_ATTR.include?(key.to_s)}
    if @account.update(account_param)
      render json: { message: "Account Settings Updated successfully"}, status: :ok
    else
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/
  def destroy
    @account.destroy
  end

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
