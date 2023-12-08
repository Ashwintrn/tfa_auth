require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do

  describe '#POST init_login' do
    context 'when the credential is true' do
      let!(:account) { FactoryBot.create(:account) }

      it 'does encoding' do
        allow_any_instance_of(Account).to receive(:authenticate).and_return(true)
        expect(Jwt).to receive(:encode)
        post :init_login, params: {email: 'dummy@example.com', password: '12345678'}
      end
      it 'returns success response' do
        allow_any_instance_of(Account).to receive(:authenticate).and_return(true)
        post :init_login, params: {email: 'dummy@example.com', password: '12345678'}
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the credential is false' do
      it 'does encoding' do
        allow_any_instance_of(Account).to receive(:authenticate).and_return(false)
        expect(Jwt).not_to receive(:encode)
        post :init_login, params: {email: 'dummy@example.com', password: '12345678'}
      end
      it 'returns success response' do
        allow_any_instance_of(Account).to receive(:authenticate).and_return(false)
        post :init_login, params: {email: 'dummy@example.com', password: '12345678'}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end 

end