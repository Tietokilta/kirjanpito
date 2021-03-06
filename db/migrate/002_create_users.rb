require 'migration_helpers'

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true, :options => "DEFAULT CHARSET=utf8" do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :level,                     :integer, :default => 0 # 0=toimihenkilö, 1=hallituslainen, 2=rahis (admin)
      
    end
  end

  def self.down
    drop_table "users"
  end
end
