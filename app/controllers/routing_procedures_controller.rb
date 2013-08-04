class RoutingProceduresController < ApplicationController
  
  before_filter :authenticate_admin
  before_filter :get_routing
  

  # GET /routing_procedures
  # GET /routing_procedures.xml
  def index
    @routing_procedures = RoutingProcedure.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @routing_procedures }
    end
  end

  # GET /routing_procedures/1
  # GET /routing_procedures/1.xml
  def show
    @routing_procedure = RoutingProcedure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @routing_procedure }
    end
  end

  # GET /routing_procedures/new
  # GET /routing_procedures/new.xml
  def new
    @routing = Routing.find(params[:routing_id])
    @routing_procedure = RoutingProcedure.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @routing_procedure }
    end
  end

  # GET /routing_procedures/1/edit
  def edit
    @routing_procedure = RoutingProcedure.find(params[:id])
  end

  # POST /routing_procedures
  # POST /routing_procedures.xml
  def create
    if @routing.routing_procedures.first(:conditions => ["routing_process_id = ?", params[:routing_procedure][:routing_process_id].to_i])
      flash[:error] = "The process already exist"
      redirect_to(@routing)
    else
      @routing_procedure = @routing.routing_procedures.new(params[:routing_procedure])
     
      respond_to do |format|
        if @routing_procedure.save
          flash[:notice] = 'RoutingProcedure was successfully created.'
          format.html { redirect_to(@routing) }
          format.xml  { render :xml => @routing_procedure, :status => :created, :location => @routing }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @routing_procedure.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /routing_procedures/1
  # PUT /routing_procedures/1.xml
  def update
    @routing_procedure = @routing.routing_procedures.find(params[:id])

    respond_to do |format|
      if @routing_procedure.update_attributes(params[:routing_procedure])
        flash[:notice] = 'Routing Procedure was successfully updated.'
        format.html { redirect_to(@routing) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @routing_procedure.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /routing_procedures/1
  # DELETE /routing_procedures/1.xml
  def destroy
    @routing_procedure = RoutingProcedure.find(params[:id])
   
    if @routing_procedure.verify_for_destroy
      flash[:notice] = "Deleted successfully"
    else
      flash[:error] = "Cannot delete the procedure because it's in use"
    end

    respond_to do |format|
      format.html { redirect_to(@routing) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_routing
    @routing = Routing.find(params[:routing_id])
  end
  
end
