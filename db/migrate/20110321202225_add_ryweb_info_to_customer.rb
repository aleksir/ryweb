require 'declarative_authorization/maintenance'

class AddRywebInfoToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :home_page, :string
    add_column :customers, :ryweb_active, :integer, :default => 0

    Authorization::Maintenance::without_access_control do
    customers = Customer.find(:all)

    customers.each do |row|
      c = Customer.find(row)
      c.ryweb_active = 1 if c.ryweb_active.nil?
      c.save
      if c.save
        puts "Yhdistyksen (#{c.title}) oletusarvot päivitettiin onnistuneesti"
      else
        puts "Yhdistyksen oletusarvojen päivitys epäonnistui"
      end
    end
  end
  end

  def self.down
    remove_column :customers, :ryweb_active
    remove_column :customers, :home_page
  end
end
