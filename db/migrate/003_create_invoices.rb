class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
    end
  end

  def self.down
    drop_table :invoices
  end
end
