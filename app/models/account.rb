class Account < ApplicationRecord
  acts_as_google_authenticated lookup_token: :mfa_secret, encrypt_secrets: true

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }

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
