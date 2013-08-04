class RoutingProcessesController < ApplicationController
  
  before_filter :authenticate_user
  # GET /processes
  # GET /processes.xml
  def index
    @processes = RoutingProcess.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @processes }
    end
  end

  # GET /processes/1
  # GET /processes/1.xml
  def show
    @process = RoutingProcess.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @process }
    end
  end

  # GET /processes/new
  # GET /processes/new.xml
  def new
    @process = RoutingProcess.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @process }
    end
  end

  # GET /processes/1/edit
  def edit
    @process = RoutingProcess.find(params[:id])
  end

  # POST /processes
  # POST /processes.xml
  def create
    @process = RoutingProcess.new(params[:routing_process])

    respond_to do |format|
      if @process.save
        flash[:notice] = 'Process was successfully created.'
        format.html { redirect_to(@process) }
        format.xml  { render :xml => @process, :status => :created, :location => @process }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @process.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /processes/1
  # PUT /processes/1.xml
  def update
    @process = RoutingProcess.find(params[:id])

    respond_to do |format|
      if @process.update_attributes(params[:routing_process])
        flash[:notice] = 'Process was successfully updated.'
        format.html { redirect_to(@process) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @process.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /processes/1
  # DELETE /processes/1.xml
  def destroy
    @process = RoutingProcess.find(params[:id])
  
    if @process.verify_for_destroy
      flash[:notice] = "Deleted successfully"
    else
      flash[:error] = "Cannot delete the process because it's in use"
    end

    respond_to do |format|
      format.html { redirect_to(routing_processes_url) }
      format.xml  { head :ok }
    end
  end
end
