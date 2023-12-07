class AccountMailer < ApplicationMailer
  def welcome_email(account_id)
    @account = Account.find_by_id(account_id)
    if Rails.env.production?
      mail(to: @account.email, subject: "Welcome to TFA Authenticator App") unless @account.nil?
    end
  end
end
