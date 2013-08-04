class RoutingsController < ApplicationController
  
  before_filter :authenticate_user
  # GET /routings
  # GET /routings.xml
  def index
    @routings = Routing.all
  end

  def show
    @routing = Routing.find(params[:id])
  end

  # GET /routings/new
  # GET /routings/new.xml
  def new
    @routing = Routing.new
  end

  # GET /routings/1/edit
  def edit
    @routing = Routing.find(params[:id])
  end

  # POST /routings
  # POST /routings.xml
  def create
    @routing = Routing.new(params[:routing])

    respond_to do |format|
      if @routing.save
        flash[:notice] = 'Routing was successfully created.'
        format.html { redirect_to(@routing) }
        format.xml  { render :xml => @routing, :status => :created, :location => @routing }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @routing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /routings/1
  # PUT /routings/1.xml
  def update
    @routing = Routing.find(params[:id])

    respond_to do |format|
      if @routing.update_attributes(params[:routing])
        flash[:notice] = 'Routing was successfully updated.'
        format.html { redirect_to(@routing) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @routing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /routings/1
  # DELETE /routings/1.xml
  def destroy
    @routing = Routing.find(params[:id])
   
    if @routing.verify_for_destroy
      flash[:notice] = "Deleted successfully"
    else
      flash[:error] = "Cannot delete the routing because it's in use"
    end

    respond_to do |format|
      format.html { redirect_to(routings_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_process
    
    @routing = Routing.find(params[:id])
    @procedure = RoutingProcedure.find(params[:procedure_id])
    
    if @routing.suspend
      flash[:error] = "The routing is currently in suspend mode"
      redirect_to(@routing)
    else
      @routing_processes = RoutingProcess.all(:order => "name") #@routing.routing_processes  #
    end
  end
  
   def attach_process
    @routing = Routing.find(params[:id])
    procedure = RoutingProcedure.find(params[:procedure_id])
    params[:routing_process] ||= []
    
    params[:routing_process].each {|pro_id, content|
    routing_process = RoutingProcess.find(pro_id.to_i)
     
    unless procedure.procedure_processes.first(:conditions => ["routing_process_id = ?", routing_process.id])
      procedure.procedure_processes.create!(:routing_process_id => routing_process.id)
    end if routing_process
     
    }
    flash[:notice] = "Operation Completed"
    redirect_to(add_process_routing_path(@routing, :procedure_id => procedure.id))
    
  end
  
  def remove_process
    routing = Routing.find(params[:id])
    procedure_process = ProcedureProcess.find(params[:procedure_process_id])
    procedure = routing.routing_procedures.find(procedure_process.routing_procedure_id)
    procedure_process.destroy
    flash[:notice] = "Process link has been successfuly removed"
    redirect_to(add_process_routing_path(routing, :procedure_id => procedure.id))
  end
  
  def add_procedure
    
    @routing = Routing.find(params[:id])
    @procedures = @routing.routing_procedures.all(:order => "position")
    
    if @routing.suspend
      flash[:error] = "The routing is currently in suspend mode"
      redirect_to(@routing)
    else
      @routing_processes = @routing.exception_processes  #RoutingProcess.all(:order => "name")  
    end
  end
  
  def attach_procedure
    @routing = Routing.find(params[:id])
    
    params[:routing_process] ||= []
    count = 0
    params[:routing_process].each {|pro_id, content|
    routing_process = RoutingProcess.find(pro_id.to_i)
    
    unless @routing.routing_procedures.first(:conditions => ["routing_process_id = ?", routing_process.id])
      @routing.routing_procedures.create!(:routing_process_id => routing_process.id, :position => @routing.routing_procedures.size.to_i + 1)
      count += 1
    end if routing_process
     
    }
    flash[:notice] = "Operation Completed"
    flash[:error] = "No process been ticked or the process already been attached" if count == 0
    redirect_to(add_procedure_routing_path(@routing))
    
  end
  
  def remove_procedure
    @routing = Routing.find(params[:id])
    procedure = @routing.routing_procedures.find(params[:procedure_id])
    procedure.destroy
    flash[:notice] = "Procedure has been successfuly removed"
    redirect_to(add_procedure_routing_path(@routing))
  end
  
  def update_sequence
    @routing = Routing.find(params[:id])
    
    params[:procedure].each do |pro_id, content|
      procedure = RoutingProcedure.find(pro_id)
      procedure.position = content[:position].to_i

      procedure.save!
    end
    flash[:notice] = "Update successfully"
    redirect_to(add_procedure_routing_path(@routing))
    
  end
  
  def add_machine
    @routing = Routing.find(params[:id])
    if @routing.suspend
      flash[:error] = "The routing is currently in suspend mode"
      redirect_to(@routing)
    else
      @procedure = RoutingProcedure.find(params[:procedure_id])
      @machines = Machine.all(:order => "machine_number")  
    end
    
  end
  
  def attach_machine
    @routing = Routing.find(params[:id])
    @procedure = RoutingProcedure.find(params[:procedure_id])

     if @routing.suspend?
       flash[:error] = "Routing has been suspended <br />"
     else
       params[:machine] ||= []
       params[:machine].each {|machine_id, content|
       machine = Machine.find(machine_id)
       unless @procedure.procedure_machines.first(:conditions => ["machine_id = ?", machine]) || @routing.procedure_machines.first(:conditions => ["machine_id = ?", machine])
         if ProcedureMachine.first(:conditions => ["routing_id != ? and machine_id = ? and suspend = 0", @routing.id, machine.id])
           flash[:error] ? flash[:error] << "Machine " + machine.machine_number +  " has already attached to other routing procedure <br />" : flash[:error] = "Machine " + machine.machine_number +  " has already attached to other routing procedure <br />"
         else
           @routing.procedure_machines.create(:machine_id => machine.id, :routing_procedure_id => @procedure.id)
           flash[:notice] ? flash[:notice] << "Machine " + machine.machine_number + " has successfully attached to routing procedure <br /> " : flash[:notice] = "Machine " + machine.machine_number + " has successfully attached to routing procedure <br /> "
         end
       end if machine
       }
     end
    
    redirect_to(add_machine_routing_path(@routing, :procedure_id => @procedure))
  end

  def remove_machine
    @procedure = RoutingProcedure.find(params[:id])
    machine = Machine.find(params[:machine_id])
    procedure_machine = @procedure.procedure_machines.first(:conditions => ["machine_id = ?", machine])
    procedure_machine.destroy
    flash[:notice] = machine.machine_number + " successfully remove from the process"
    redirect_to(add_machine_routing_path(@procedure.routing, :procedure_id => @procedure))
  end
  
  def show_employees
    @procedure = RoutingProcedure.find(params[:id])
    @routing = @procedure.routing
    @machine = Machine.find(params[:machine_id])
  end
  
  def show_products
    @procedure = RoutingProcedure.find(params[:id])
    @routing = @procedure.routing
    @machine = Machine.find(params[:machine_id])
  end
  
  def show_machines
    @procedure = RoutingProcedure.find(params[:id])
    @routing = @procedure.routing
    @machines = @procedure.machines
  end
  
  def enable
    @routing = Routing.find(params[:id])
    msg_id = @routing.enable_process
    case msg_id
    when 1
      flash[:notice] = "Routing successfully enable"
    when -1
      flash[:notice] = "Routing failed to enable because the attached machines is in used"
    end
  
    redirect_to(@routing)  
    
  end
  
  def disable
    @routing = Routing.find(params[:id])
    @routing.disable_process
    redirect_to(@routing)
  end
  
end
