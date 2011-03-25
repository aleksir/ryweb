class IndexController < ApplicationController
  
  # GET /customers
  # GET /customers.xml
 def index
    @customers = Customer.find(:all, :conditions => ["customer_type == ?",10],:order => "title ASC")
    @customer_index = @customers.group_by { |c| c.title.first }

    @international = Customer.find(:all, :conditions => ["customer_type == ?",30],:order => "title ASC")
    @international_index = @international.group_by { |c| c.title.first }

    @areas = Customer.find(:all, :conditions => ["customer_type == ?",20],:order => "title ASC")
    @areas_index = @areas.group_by { |c| c.title.first }

   # net radio occasions
    date_now = DateTime.now
    first_date = date_now.beginning_of_month # first day at 0:00:00
    last_date = date_now.advance(:months => 2)
    last_date = last_date.beginning_of_month # first day of next month at 0:00:00

    @occasions = Occasion.find_without_customer(:all, :joins => :occasion_type, :conditions => ["start_time >= ? AND start_time < ? AND state = ? AND occasion_types.visibility = ? AND net_radio = ?", DateTime.now.beginning_of_day, last_date, 20,20,1], :order => 'start_time ')
    @occasion_months = @occasions.group_by { |o| o.start_time.beginning_of_month }
    
    respond_to do |format|
      format.html { render :layout => false }# index.html.erb
      format.xml  { render :xml => @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.xml
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false }# show.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  def occasions
    @customer = Customer.find(params[:id])
    Customer.current = @customer
    calendar_length = 5
     date_now = DateTime.now
    last_date = date_now.advance(:months => calendar_length)
    @occasions = Occasion.find(:all, :joins => :occasion_type, :conditions => ["start_time >= ? AND start_time < ? AND state = ? AND occasion_types.visibility = ? ", DateTime.now.beginning_of_day, last_date, 20,20], :order => 'start_time ')

    respond_to do |format|
      #      format.xml  { render :xml => @occasions_xml}
      format.xml  { render :layout => false}
    end

  end

  def locations
    @customer = Customer.find(params[:id])
    Customer.current = @customer

    @locations = Location.find(:all)

    respond_to do |format|
      format.xml  { render :xml => @locations}
    end

  end

end
