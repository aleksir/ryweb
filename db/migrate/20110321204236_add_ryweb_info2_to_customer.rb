require 'declarative_authorization/maintenance'

class AddRywebInfo2ToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :start_date, :date
    add_column :customers, :customer_type, :integer, :default => 10

    Authorization::Maintenance::without_access_control do
    customers = Customer.find(:all)

    customers.each do |row|
      c = Customer.find(row)
      c.customer_type = 10 if c.customer_type.nil?
      c.start_date = c.created_at.utc.to_date if c.start_date.nil?
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
    remove_column :customers, :start_date
    remove_column :customers, :customer_type
  end
end
