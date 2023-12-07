class AccountsController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_account, except: %i[create index]

  # GET /accounts
  # def index
  #   @accounts = Account.all
  #   render json: @accounts, status: :ok
  # end

  # GET /accounts/{accountname}
  def show
    render json: @account.as_json(except: :password_digest), status: :ok
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)
    if @account.save
      render json: @account, status: :created
    else
      render json: { errors: @account.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /accounts/{accountname}
  def update
    unless @account.update(account_params)
      render json: { errors: @account.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /accounts/{accountname}
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
      :name, :email, :password, :password_confirmation
    )
  end
end
