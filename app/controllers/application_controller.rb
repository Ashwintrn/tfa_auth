class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_session
    if !(account_mfa_session = AccountMfaSession.find) && (account_mfa_session ? account_mfa_session.record == @current_account : !account_mfa_session)
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

end
