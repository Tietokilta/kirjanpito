require 'migration_helpers'

class CreateAccountTypes < ActiveRecord::Migration
  def self.up
    create_table :account_types, :options => "DEFAULT CHARSET=utf8"  do |t|
      t.column "description",       :string
    end

  end

  def self.down
    drop_table :account_types
  end
end

