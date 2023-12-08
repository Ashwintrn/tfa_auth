class Account < ApplicationRecord
  acts_as_google_authenticated lookup_token: :mfa_secret, encrypt_secrets: true

  has_secure_password

  PASSWORD_FORMAT = /\A
  (?=.{12,})          # Must contain 8 or more characters
  (?=.*\d)           # Must contain a digit
  (?=.*[a-z])        # Must contain a lower case character
  (?=.*[A-Z])        # Must contain an upper case character
  (?=.*[[:^alnum:]]) # Must contain a symbol
  /x

  validates :email, presence: true, uniqueness: true
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, format: {
    with: PASSWORD_FORMAT, message: "should have length more than 12 and contain a digit, a lower case and an upper case alphabet and a symbol"
    }, if: -> { new_record? || !password.nil? }

  #when user is newly created we send them welcome email
  after_create :send_welcome_email 
  
  #when tfa status is changed, we reset session and send email 
  after_update :email_qr_and_reset_session, if: Proc.new { saved_change_to_attribute?(:tfa_status) }
  
  #email containing welcome message with insturction to use the API
  def send_welcome_email
    self.set_google_secret if google_secret.nil?
    AccountMailer.welcome_email(id).deliver_now
  end

  def email_qr_and_reset_session
    logout_actions
    send_welcome_email if tfa_status
  end

  # tfa session is reset while access_token session stays intact
  def logout_actions
    self.update_column(:mfa_secret, nil)
    AccountMfaSession.destroy
    #blacklisting tokens can be implemented but for now the tfa session handles the case
  end
end
