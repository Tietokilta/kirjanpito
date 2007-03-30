require 'migration_helpers'

class AccountsUsers < ActiveRecord::Migration
  def self.up
    create_table :accounts_users do |t|
      t.column "account_id", :integer
      t.column "user_id",    :integer
    end
    
    foreign_key(:accounts_users, :account_id, :accounts)
    foreign_key(:accounts_users, :user_id, :users)
  end

  def self.down
    drop_foreign_key(:accounts_users, :account_id, :accounts)
    drop_foreign_key(:accounts_users, :user_id, :users)
    drop_table :accounts_users
  end
end
