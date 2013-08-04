class LoginRecordsController < ApplicationController
  
  before_filter :authenticate_user
  # GET /login_records
  # GET /login_records.xml
  def index
    
    if is_admin?
      @machines = Machine.all(:order => "machine_number")
      @employees = Employee.all(:order => "employee_number")
      @search = LoginRecord.active.search(params[:search])
      @login_records = @search.all
    elsif is_supervisor?
      @machines = current_user.machines
      @employees = current_user.belonging_employees
      @search = LoginRecord.active.search(params[:search])
      login_records = @search.all
      @login_records = current_user.related_machines_operator_login(login_records)
      
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @login_records }
    end
  end

  # GET /login_records/1
  # GET /login_records/1.xml
  def show
    @login_record = LoginRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @login_record }
    end
  end
  
  def unfreeze
    @login_record = LoginRecord.find(params[:id])
    @login_record.logout = true
    @login_record.save
    flash[:notice] = "Account has been unfreezed"
    redirect_to login_records_url
  end

  # GET /login_records/new
  # GET /login_records/new.xml
#  def new
#    @login_record = LoginRecord.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @login_record }
#    end
#  end

  # GET /login_records/1/edit
#  def edit
#    @login_record = LoginRecord.find(params[:id])
#  end

  # POST /login_records
  # POST /login_records.xml
#  def create
#    @login_record = LoginRecord.new(params[:login_record])
#
#    respond_to do |format|
#      if @login_record.save
#        flash[:notice] = 'LoginRecord was successfully created.'
#        format.html { redirect_to(@login_record) }
#        format.xml  { render :xml => @login_record, :status => :created, :location => @login_record }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @login_record.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /login_records/1
  # PUT /login_records/1.xml
#  def update
#    @login_record = LoginRecord.find(params[:id])
#
#    respond_to do |format|
#      if @login_record.update_attributes(params[:login_record])
#        flash[:notice] = 'LoginRecord was successfully updated.'
#        format.html { redirect_to(@login_record) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @login_record.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /login_records/1
  # DELETE /login_records/1.xml
#  def destroy
#    @login_record = LoginRecord.find(params[:id])
#    @login_record.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(login_records_url) }
#      format.xml  { head :ok }
#    end
#  end
end
