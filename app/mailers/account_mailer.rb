class AccountMailer < ApplicationMailer
  def welcome_email(account_id)
    @account = Account.find_by_id(account_id)
    Rails.logger.info "account email: #{@account&.email}"
    mail(to: "ashwinkumar9816@gmail.com", subject: "Welcome to Our App") unless @account.nil?
  end
end
