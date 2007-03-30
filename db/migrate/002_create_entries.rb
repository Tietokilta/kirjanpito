class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
    end
  end

  def self.down
    drop_table :entries
  end
end
