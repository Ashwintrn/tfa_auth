class Account < ApplicationRecord
  acts_as_google_authenticated lookup_token: :mfa_secret, encrypt_secrets: true

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
end
