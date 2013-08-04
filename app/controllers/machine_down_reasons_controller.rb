class MachineDownReasonsController < ApplicationController
  
  before_filter :authenticate_admin
  # GET /machine_down_reasons
  # GET /machine_down_reasons.xml
  def index
    @machine_down_reasons = MachineDownReason.all(:order => "routing_process_id").paginate(:page => params[:page], :per_page => 50)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @machine_down_reasons }
    end
  end

  # GET /machine_down_reasons/1
  # GET /machine_down_reasons/1.xml
  def show
    @machine_down_reason = MachineDownReason.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @machine_down_reason }
    end
  end

  # GET /machine_down_reasons/new
  # GET /machine_down_reasons/new.xml
  def new
    @machine_down_reason = MachineDownReason.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @machine_down_reason }
    end
  end

  # GET /machine_down_reasons/1/edit
  def edit
    @machine_down_reason = MachineDownReason.find(params[:id])
  end

  # POST /machine_down_reasons
  # POST /machine_down_reasons.xml
  def create
    @machine_down_reason = MachineDownReason.new(params[:machine_down_reason])

    respond_to do |format|
      if @machine_down_reason.save
        flash[:notice] = 'MachineDownReason was successfully created.'
        format.html { redirect_to(@machine_down_reason) }
        format.xml  { render :xml => @machine_down_reason, :status => :created, :location => @machine_down_reason }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @machine_down_reason.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /machine_down_reasons/1
  # PUT /machine_down_reasons/1.xml
  def update
    @machine_down_reason = MachineDownReason.find(params[:id])

    respond_to do |format|
      if @machine_down_reason.update_attributes(params[:machine_down_reason])
        flash[:notice] = 'MachineDownReason was successfully updated.'
        format.html { redirect_to(@machine_down_reason) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @machine_down_reason.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /machine_down_reasons/1
  # DELETE /machine_down_reasons/1.xml
  def destroy
    @machine_down_reason = MachineDownReason.find(params[:id])
    if @machine_down_reason.verify_for_destroy
      flash[:notice] = "Deleted successfully"
    else
      flash[:error] = "Cannot delete the reason because it's in use"
    end
    respond_to do |format|
      format.html { redirect_to(machine_down_reasons_url) }
      format.xml  { head :ok }
    end
  end
end
