require 'declarative_authorization/maintenance'

class UpdateCustomerInformation < ActiveRecord::Migration
  def self.up
    Authorization::Maintenance::without_access_control do
    customers = Customer.find(:all)

    customers.each do |row|
      c = Customer.find(row)
      c.customer_type = 10 if c.customer_type.nil?
      c.start_date = c.created_at.utc.to_date if c.start_date.nil?
      c.save
      if c.save
        puts "Yhdistyksen (#{c.title}) tiedot päivitettiin onnistuneesti"
      else
        puts "Yhdistyksen oletusarvojen päivitys epäonnistui"
      end
    end
  end
  end

  def self.down
  end
end
