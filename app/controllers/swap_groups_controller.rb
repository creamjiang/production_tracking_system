class SwapGroupsController < ApplicationController
  before_filter :authenticate_user
  # GET /swap_groups
  # GET /swap_groups.xml
  def index
    @swap_groups = SwapGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @swap_groups }
    end
  end

  # GET /swap_groups/1
  # GET /swap_groups/1.xml
  def show
    @swap_group = SwapGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @swap_group }
    end
  end

  # GET /swap_groups/new
  # GET /swap_groups/new.xml
  def new
    @swap_group = SwapGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @swap_group }
    end
  end

  # GET /swap_groups/1/edit
  def edit
    @swap_group = SwapGroup.find(params[:id])
  end

  # POST /swap_groups
  # POST /swap_groups.xml
  def create
    @swap_group = SwapGroup.new(params[:swap_group])

    respond_to do |format|
      if @swap_group.save
        format.html { redirect_to(@swap_group, :notice => 'SwapGroup was successfully created.') }
        format.xml  { render :xml => @swap_group, :status => :created, :location => @swap_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @swap_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /swap_groups/1
  # PUT /swap_groups/1.xml
  def update
    @swap_group = SwapGroup.find(params[:id])

    respond_to do |format|
      if @swap_group.update_attributes(params[:swap_group])
        format.html { redirect_to(@swap_group, :notice => 'SwapGroup was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @swap_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /swap_groups/1
  # DELETE /swap_groups/1.xml
  def destroy
    @swap_group = SwapGroup.find(params[:id])
    @swap_group.destroy

    respond_to do |format|
      format.html { redirect_to(swap_groups_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_process
    @swap_group = SwapGroup.find(params[:id])
    @processes = (RoutingProcess.all) - (@swap_group.routing_processes)
  end
  
  def attach_process
    @swap_group = SwapGroup.find(params[:id])
    params[:process] ||= []
    
    params[:process].each {|pro_id, content|
     unless @swap_group.swap_group_items.first(:conditions => ["routing_process_id = ?", pro_id])
       @swap_group.swap_group_items.create!(:routing_process_id => pro_id)
     end
    }
    flash[:notice] = "Operation Completed"
    redirect_to(add_process_swap_group_path(@swap_group))
  end
  
  def remove_process
    @swap_group = SwapGroup.find(params[:id])
    params[:process] ||= []
    
    params[:process].each {|pro_id, content|
     SwapGroupItem.find(pro_id).destroy
    }
    flash[:notice] = "Operation Completed"
    redirect_to(add_process_swap_group_path(@swap_group))
  end
  
end
