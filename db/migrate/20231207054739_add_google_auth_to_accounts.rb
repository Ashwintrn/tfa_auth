class AddGoogleAuthToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :google_secret, :string
    add_column :accounts, :mfa_secret, :integer
  end
end
