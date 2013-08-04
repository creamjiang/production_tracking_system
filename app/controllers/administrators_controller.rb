class AdministratorsController < ApplicationController
  
  before_filter :authenticate_admin
  # GET /administrators
  # GET /administrators.xml
  def index
    @administrators = Administrator.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @administrators }
    end
  end

  # GET /administrators/1
  # GET /administrators/1.xml
  def show
    @administrator = Administrator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @administrator }
    end
  end

  # GET /administrators/new
  # GET /administrators/new.xml
  def new
    @administrator = Administrator.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @administrator }
    end
  end

  # GET /administrators/1/edit
  def edit
    @administrator = Administrator.find(params[:id])
  end

  # POST /administrators
  # POST /administrators.xml
  def create
    @administrator = Administrator.new(params[:administrator])
    @administrator.password = params[:administrator][:password]
    @administrator.password_confirmation = params[:administrator][:password_confirmation]

    respond_to do |format|
      if @administrator.save
        flash[:notice] = 'Administrator was successfully created.'
        format.html { redirect_to(@administrator) }
        format.xml  { render :xml => @administrator, :status => :created, :location => @administrator }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @administrator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /administrators/1
  # PUT /administrators/1.xml
  def update
    @administrator = Administrator.find(params[:id])

    respond_to do |format|
      if @administrator.update_attributes(params[:administrator])
        flash[:notice] = 'Administrator was successfully updated.'
        format.html { redirect_to(@administrator) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @administrator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /administrators/1
  # DELETE /administrators/1.xml
  def destroy
    @administrator = Administrator.find(params[:id])
    checked, msg = @administrator.verify_destroy
    if checked
      flash[:notice] = msg
    else
      flash[:error] = msg
    end

    respond_to do |format|
      format.html { redirect_to(administrators_url) }
      format.xml  { head :ok }
    end
  end
  
  def change_password
    @administrator = Administrator.find(params[:id])
  end

  def update_password
     @administrator = Administrator.find(params[:id])
     @administrator.password = params[:administrator][:password]
     @administrator.password_confirmation = params[:administrator][:password_confirmation]

     if params[:administrator][:password].length >= 6
       if params[:administrator][:password] != params[:administrator][:password_confirmation]
          flash[:error] = 'password confirmation is incorrect'
          render :action => 'change_password'
       else
          if @administrator.save
            flash[:notice] = 'password updated'
            redirect_to(@administrator)
          else
            flash[:error] = 'please retype your password'
            render :action => 'change_password'
          end
       end
     elsif params[:administrator][:password] == ""
       flash[:error] = 'password cannot be blank'
       render :action => 'change_password'

     else
        flash[:error] = 'password cannot be less than 6 characters'
        render :action => "change_password"
    end
  end
  
  def attach_procedure
    @administrator = Administrator.find(params[:id])
    @procedures = @administrator.exception_procedures  #RoutingProcedure.all(:order => "routing_id, routing_process_id")
  end
  
  def add_procedure
    administrator = Administrator.find(params[:id])
    
    params[:procedure] ||= []
    
    params[:procedure].each {|pro_id, content|
     pro = RoutingProcedure.find(pro_id)
     unless ProcedureAdmin.first(:conditions => ["administrator_id = ? and routing_procedure_id = ?", administrator.id, pro.id])
      
       ProcedureAdmin.create(:administrator_id => administrator.id, :routing_procedure_id => pro.id)
       flash[:notice] = "Procedure(s) has successfully attached to administrator "
     end if pro
     
    }
    redirect_to(attach_procedure_administrator_path(administrator))
    
  end
  
  def remove_procedure
    administrator = Administrator.find(params[:id])
    procedure = RoutingProcedure.find(params[:procedure_id])
   
    op = administrator.procedure_admins.first(:conditions => ["routing_procedure_id = ?", procedure.id])
    op.destroy if op
    flash[:notice] = "procedure successfully remove from the machine operator"
    redirect_to(attach_procedure_administrator_path(administrator))
  end
  
  
end
