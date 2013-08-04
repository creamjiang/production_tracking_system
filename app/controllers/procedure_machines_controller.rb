class ProcedureMachinesController < ApplicationController
  before_filter :authenticate_admin
  # GET /procedure_machines
  # GET /procedure_machines.xml
  def index
    @procedure_machines = ProcedureMachine.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @procedure_machines }
    end
  end

  # GET /procedure_machines/1
  # GET /procedure_machines/1.xml
  def show
    @procedure_machine = ProcedureMachine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @procedure_machine }
    end
  end

  # GET /procedure_machines/new
  # GET /procedure_machines/new.xml
  def new
    @procedure_machine = ProcedureMachine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @procedure_machine }
    end
  end

  # GET /procedure_machines/1/edit
  def edit
    @procedure_machine = ProcedureMachine.find(params[:id])
  end

  # POST /procedure_machines
  # POST /procedure_machines.xml
  def create
    @procedure_machine = ProcedureMachine.new(params[:procedure_machine])

    respond_to do |format|
      if @procedure_machine.save
        flash[:notice] = 'ProcedureMachine was successfully created.'
        format.html { redirect_to(@procedure_machine) }
        format.xml  { render :xml => @procedure_machine, :status => :created, :location => @procedure_machine }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @procedure_machine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /procedure_machines/1
  # PUT /procedure_machines/1.xml
  def update
    @procedure_machine = ProcedureMachine.find(params[:id])

    respond_to do |format|
      if @procedure_machine.update_attributes(params[:procedure_machine])
        flash[:notice] = 'ProcedureMachine was successfully updated.'
        format.html { redirect_to(@procedure_machine) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @procedure_machine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /procedure_machines/1
  # DELETE /procedure_machines/1.xml
  def destroy
    @procedure_machine = ProcedureMachine.find(params[:id])
    @procedure_machine.destroy

    respond_to do |format|
      format.html { redirect_to(procedure_machines_url) }
      format.xml  { head :ok }
    end
  end
end
