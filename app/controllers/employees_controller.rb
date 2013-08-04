class EmployeesController < ApplicationController
  before_filter :authenticate_admin
  # GET /employees
  # GET /employees.xml
  def index
    @search = Employee.search(params[:search])
    @employees = @search.all(:include => :department).paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @employees }
    end
  end

  # GET /employees/1
  # GET /employees/1.xml
  def show
    @employee = Employee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @employee }
    end
  end

  # GET /employees/new
  # GET /employees/new.xml
  def new
    @employee = Employee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @employee }
    end
  end

  # GET /employees/1/edit
  def edit
    @employee = Employee.find(params[:id])
  end

  # POST /employees
  # POST /employees.xml
  def create
    @employee = Employee.new(params[:employee])
    @employee.employee_number = params[:employee][:employee_number]
    @employee.password = params[:employee][:password]
    @employee.password_confirmation = params[:employee][:password_confirmation]
    @employee.department_id = params[:employee][:department_id]

    respond_to do |format|
      if @employee.save
        flash[:notice] = 'Employee was successfully created.'
        format.html { redirect_to(@employee) }
        format.xml  { render :xml => @employee, :status => :created, :location => @employee }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /employees/1
  # PUT /employees/1.xml
  def update
    @employee = Employee.find(params[:id])
    @employee.employee_number = params[:employee][:employee_number]
    @employee.department_id = params[:employee][:department_id]
    
    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        flash[:notice] = 'Employee was successfully updated.'
        format.html { redirect_to(@employee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.xml
  def destroy
    @employee = Employee.find(params[:id])
    if @employee.verify_for_destroy
      flash[:notice] = "Deleted successfully"
    else
      flash[:error] = "Cannot delete the employee because it's in use"
    end

    respond_to do |format|
      format.html { redirect_to(employees_url) }
      format.xml  { head :ok }
    end
  end
  
  
  
  def change_password
    @employee = Employee.find(params[:id])
  end

  def update_password
     @employee = Employee.find(params[:id])
     @employee.password = params[:employee][:password]
     @employee.password_confirmation = params[:employee][:password_confirmation]

     if params[:employee][:password].length >= 6
       if params[:employee][:password] != params[:employee][:password_confirmation]
          flash[:error] = 'password confirmation is incorrect'
          render :action => 'change_password'
       else
          if @employee.save
            flash[:notice] = 'password updated'
            redirect_to(@employee)
          else
            flash[:error] = 'please retype your password'
            render :action => 'change_password'
          end
       end
     elsif params[:employee][:password] == ""
       flash[:error] = 'password cannot be blank'
       render :action => 'change_password'

     else
        flash[:error] = 'password cannot be less than 6 characters'
        render :action => "change_password"
    end
  end
  

  
  
end
