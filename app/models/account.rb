class Account < ApplicationRecord
  acts_as_google_authenticated lookup_token: :mfa_secret, encrypt_secrets: true

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }

  after_create :send_welcome_email

  after_update :email_qr_and_reset_session, if: Proc.new { saved_change_to_attribute?(:tfa_status) }
  
  def send_welcome_email
    AccountMailer.welcome_email(id).deliver_now
  end

  def email_qr_and_reset_session
    logout_actions
    send_welcome_email if tfa_status
  end

  def logout_actions
    self.update_column(:mfa_secret, nil)
    AccountMfaSession.destroy
  end
end
