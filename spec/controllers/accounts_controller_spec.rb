require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let(:account) { FactoryBot.create(:account) }

  before :each do
    allow(controller).to receive(:authorize_session).and_return(true)
    controller.instance_variable_set(:@current_account, account)
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show
      res = JSON.parse(response.body)
      expected_result = account.as_json(except: AccountsController::SENSITIVE_DATA)
      expect(res).to eq(expected_result)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) { { email: 'test1@example.com', password: '12345678' } }
      it 'creates a new Account' do
        expect {
          post :create, params: valid_attributes
        }.to change(Account, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it 'renders a JSON response with the new account' do
        expect_any_instance_of(Account).to receive(:set_google_secret)
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      context 'when account is created but setting google secret' do
        it 'renders a JSON response as unprocessable entity' do
          expect_any_instance_of(Account).to receive(:set_google_secret).and_raise("Some issue")
          post :create, params: valid_attributes
          expect(response).to have_http_status(:unprocessable_entity)
          res = JSON.parse(response.body)
          expect(res["errors"]).to eq('Account created but unable to set google key. Please contact your operator')
        end
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { email: 'test2@example.com', password: '123' } }

      it 'renders a JSON response with errors for the new account' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) { { name: 'Mudhumalai' }}
    let(:unchangable_attr) { {mfa_secret: '3456789'} }

    it 'updates the requested account' do
      put :update, params: new_attributes
      account.reload
      expect(account.name).to eq('Mudhumalai')
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq("Account Settings has been updated successfully")
    end

    context 'when given an un-editable attribute to update' do
      it "doesn't update but gives ok message" do
        put :update, params: unchangable_attr
        expect(response).to have_http_status(:ok)
        account.reload
        expect(account.mfa_secret).not_to eq(unchangable_attr[:mfa_secret])
      end
    end
  end
end
