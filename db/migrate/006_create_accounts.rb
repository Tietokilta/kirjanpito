require 'migration_helpers'

class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.column "name",              :string
      t.column "fiscal_period_id",  :integer
      t.column "number",            :integer
      t.column "description",       :string
      t.column "type_id",           :integer
      t.column "parent_id",         :integer
    end
  end

  def self.down
    drop_table :accounts
  end
end
