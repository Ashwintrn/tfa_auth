class ApplicationController < ActionController::API
  include ActionController::Cookies

  def not_found
    render json: { error: 'not_found' }
  end

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

  def authorize_session
    authorize_request
    if @current_account&.tfa_status
      if !(account_mfa_session = AccountMfaSession.find) && (account_mfa_session ? account_mfa_session.record == @current_account : !account_mfa_session)
        render json: { error: 'Unable to Authorize, Please try again' }, status: :unauthorized
      end
    end
  end

end
