require 'rails_helper'

RSpec.describe AccountMfaSessionController, type: :controller do
  let(:account) { FactoryBot.create(:account) }

  before :each do
    allow(controller).to receive(:authorize_request).and_return(true)
    controller.instance_variable_set(:@current_account, account)
  end

  describe 'POST #tfa_login' do

    context 'when google autheticates true' do
      it 'should create MFA session' do
        allow_any_instance_of(Account).to receive(:google_authentic?).and_return(true)
        expect(AccountMfaSession).to receive(:create)
        post :tfa_login, params: { mfa_code: '123456' }
      end
      it 'should return status ok' do
        allow_any_instance_of(Account).to receive(:google_authentic?).and_return(true)
        allow(AccountMfaSession).to receive(:create)
        expect(response).to have_http_status(:ok)
        post :tfa_login, params: { mfa_code: '123456' }
      end
    end

    context 'when google autheticates false' do
      it 'should not create MFA session' do
        allow_any_instance_of(Account).to receive(:google_authentic?).and_return(false)
        expect(AccountMfaSession).not_to receive(:create)
        post :tfa_login, params: { mfa_code: '123456' }
      end
      it 'should return status ok' do
        allow_any_instance_of(Account).to receive(:google_authentic?).and_return(false)
        post :tfa_login, params: { mfa_code: '123456' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #logout' do
    it 'logs out the current account and renders a success JSON response' do
      allow_any_instance_of(Account).to receive(:logout_actions).and_return(true)
      delete :logout
      expect(response).to have_http_status(:ok)
    end

    it 'renders an error JSON response if an exception occurs' do
      allow_any_instance_of(Account).to receive(:logout_actions).and_raise('Some error')
      delete :logout
      expect(response).to have_http_status(422)
    end
  end
end
