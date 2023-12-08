require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { FactoryBot.create(:account) }

  describe 'validations' do
    let(:account1) { FactoryBot.create(:account) }

    it "is invalid without email" do
      expect(build(:account, email: '')).to_not be_valid
    end
    it "is invalid with invalid email" do
      expect(build(:account, email: "dummydotcom")).to_not be_valid
    end
    it "is invalid with invalid email" do
      expect(build(:account, password: "123")).to_not be_valid
    end
  end

  describe 'callbacks' do

    it 'sends a welcome email after create' do
      account1 = build(:account)
      expect(AccountMailer).to receive(:welcome_email).and_return(double(deliver_now: true))
      account1.save
    end

    it 'sends a welcome email and resets session after updating tfa_status' do
      expect_any_instance_of(Account).to receive(:send_welcome_email).once
      expect_any_instance_of(Account).to receive(:logout_actions).once
      account.update({tfa_status: false})
    end

    it 'does not send an email or reset session if tfa_status is not changed' do
      expect(account).not_to receive(:send_welcome_email)
      expect(account).not_to receive(:logout_actions)
      account.update(name: 'Updated Name')
    end
  end

  describe '#email_qr_and_reset_session' do
    it 'sends a welcome email and resets session' do
      expect(account).to receive(:send_welcome_email)
      expect(account).to receive(:logout_actions)
      account.email_qr_and_reset_session
    end
  end

  describe '#logout_actions' do
    it 'resets the session' do
      allow(AccountMfaSession).to receive(:destroy).and_return(true)
      account.update(mfa_secret: 'some_secret')
      expect { account.logout_actions }.to change { account.reload.mfa_secret }.to(nil)
    end
  end
end
