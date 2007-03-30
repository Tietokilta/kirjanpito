class CreateBudgets < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
    end
  end

  def self.down
    drop_table :budgets
  end
end
