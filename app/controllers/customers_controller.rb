class CustomersController < ApplicationController
  filter_resource_access
  
  # GET /customers
  # GET /customers.xml
  def index
    @customers = Customer.with_permissions_to(:index).search(params[:search],params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.xml
  def show
    @customer = Customer.with_permissions_to(:show).find(params[:id])
    get_forward_email
    @customer.ui_template = UiTemplate.new unless @customer.ui_template

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.xml
  def new
    @customer = Customer.new
    @ui_templates = UiTemplate.find(:all)
    @customer.ui_template = UiTemplate.new unless @customer.ui_template

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.with_permissions_to(:edit).find(params[:id])
    get_forward_email
    @ui_templates = UiTemplate.find(:all)
  end

  # POST /customers
  # POST /customers.xml
  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        update_forward_email
        flash[:notice] = 'Uusi yhdistys lisätty.'
        format.html { redirect_to(customer_url(:id => @customer)) }        
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
      else
        @ui_templates = UiTemplate.find(:all)
        flash[:error] = 'Uuden yhdistyksen lisäys epäonnistui.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    @customer = Customer.with_permissions_to(:update).find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        update_forward_email
        flash[:notice] = 'Yhdistyksen tiedot päivitetty.'
        format.html { redirect_to(customer_url) }        
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.xml
  def destroy
    @customer = Customer.with_permissions_to(:destroy).find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url) }
      format.xml  { head :ok }
    end
  end

  private

  def update_forward_email
    begin
      RestClient.put( RYWEB["email_alias"]["server_url"] + "/forward/" + @customer.name + "@" + RYWEB["email_alias"]["domain"],
                      :destination => @customer.forward_email )
    rescue
      logger.info "Can't connect to Email Alias server (#{RYWEB["email_alias"]["server_url"]})"
    end
  end

  def get_forward_email
    begin
      result = RestClient.get RYWEB["email_alias"]["server_url"] + "/forward/" + @customer.name + "@" + RYWEB["email_alias"]["domain"]
      unless result.empty?
        @customer.forward_email = JSON.parse(result)["destination"]
      end
    rescue
      logger.info "Can't connect to Email Alias server (#{RYWEB["email_alias"]["server_url"]})"
    end
  end
end
