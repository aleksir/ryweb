require 'declarative_authorization/maintenance'

class AddRywebInfoToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :home_page, :string
    add_column :customers, :ryweb_active, :integer, :default => 0
  end

  def self.down
    remove_column :customers, :ryweb_active
    remove_column :customers, :home_page
  end
end
