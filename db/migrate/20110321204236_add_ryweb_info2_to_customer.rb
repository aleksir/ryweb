require 'declarative_authorization/maintenance'

class AddRywebInfo2ToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :start_date, :date
    add_column :customers, :customer_type, :integer, :default => 10
  end

  def self.down
    remove_column :customers, :start_date
    remove_column :customers, :customer_type
  end
end
