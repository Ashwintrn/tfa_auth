class AddTfaSwitchToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :tfa_status, :boolean, default: true
  end
end
