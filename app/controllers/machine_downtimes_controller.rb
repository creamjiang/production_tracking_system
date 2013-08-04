class MachineDowntimesController < ApplicationController
  
  before_filter :authenticate_admin
  # GET /machine_downtimes
  # GET /machine_downtimes.xml
  def index
    @search = MachineDowntime.search(params[:search])
    @machine_downtimes = @search.all.paginate(:page => params[:page], :per_page => 50)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @machine_downtimes }
    end
  end

  # GET /machine_downtimes/1
  # GET /machine_downtimes/1.xml
  def show
    @machine_downtime = MachineDowntime.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @machine_downtime }
    end
  end

  # GET /machine_downtimes/new
  # GET /machine_downtimes/new.xml
#  def new
#    @machine_downtime = MachineDowntime.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @machine_downtime }
#    end
#  end

  # GET /machine_downtimes/1/edit
#  def edit
#    @machine_downtime = MachineDowntime.find(params[:id])
#  end

  # POST /machine_downtimes
  # POST /machine_downtimes.xml
#  def create
#    @machine_downtime = MachineDowntime.new(params[:machine_downtime])
#
#    respond_to do |format|
#      if @machine_downtime.save
#        flash[:notice] = 'MachineDowntime was successfully created.'
#        format.html { redirect_to(@machine_downtime) }
#        format.xml  { render :xml => @machine_downtime, :status => :created, :location => @machine_downtime }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @machine_downtime.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /machine_downtimes/1
  # PUT /machine_downtimes/1.xml
#  def update
#    @machine_downtime = MachineDowntime.find(params[:id])
#
#    respond_to do |format|
#      if @machine_downtime.update_attributes(params[:machine_downtime])
#        flash[:notice] = 'MachineDowntime was successfully updated.'
#        format.html { redirect_to(@machine_downtime) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @machine_downtime.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /machine_downtimes/1
  # DELETE /machine_downtimes/1.xml
#  def destroy
#    @machine_downtime = MachineDowntime.find(params[:id])
#    @machine_downtime.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(machine_downtimes_url) }
#      format.xml  { head :ok }
#    end
#  end
end
