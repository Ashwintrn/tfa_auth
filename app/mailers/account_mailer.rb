class AccountMailer < ApplicationMailer
  def welcome_email(account_id) #email containing instruction and qr code link is sent to the welcome user
    @account = Account.find_by_id(account_id)
    if Rails.env.production? || Rails.env.development?
      mail(to: @account.email, subject: "Welcome to TFA Authenticator App") unless @account.nil?
    end
  end
end
