class WorkingStatesController < ApplicationController
  
  before_filter :authenticate_user
  # GET /working_states
  # GET /working_states.xml
  def index
    @working_states = WorkingState.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @working_states }
    end
  end

  # GET /working_states/1
  # GET /working_states/1.xml
  def show
    @working_state = WorkingState.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @working_state }
    end
  end

  # GET /working_states/new
  # GET /working_states/new.xml
#  def new
#    @working_state = WorkingState.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @working_state }
#    end
#  end

  # GET /working_states/1/edit
#  def edit
#    @working_state = WorkingState.find(params[:id])
#  end

  # POST /working_states
  # POST /working_states.xml
#  def create
#    @working_state = WorkingState.new(params[:working_state])
#
#    respond_to do |format|
#      if @working_state.save
#        flash[:notice] = 'WorkingState was successfully created.'
#        format.html { redirect_to(@working_state) }
#        format.xml  { render :xml => @working_state, :status => :created, :location => @working_state }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @working_state.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /working_states/1
  # PUT /working_states/1.xml
#  def update
#    @working_state = WorkingState.find(params[:id])
#
#    respond_to do |format|
#      if @working_state.update_attributes(params[:working_state])
#        flash[:notice] = 'WorkingState was successfully updated.'
#        format.html { redirect_to(@working_state) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @working_state.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /working_states/1
  # DELETE /working_states/1.xml
#  def destroy
#    @working_state = WorkingState.find(params[:id])
#    @working_state.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(working_states_url) }
#      format.xml  { head :ok }
#    end
#  end
end
