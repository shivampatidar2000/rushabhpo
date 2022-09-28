class ChangeUserTypeToIntegerInAccounts < ActiveRecord::Migration[6.0]
  def change
    change_column :accounts, :user_type, :integer, using: 'user_type::integer'
  end
end
