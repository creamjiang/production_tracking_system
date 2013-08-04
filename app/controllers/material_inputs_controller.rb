class MaterialInputsController < ApplicationController
  before_filter :authenticate_user
  # GET /material_inputs
  # GET /material_inputs.xml
  def index
     if params[:criteria] and params[:criteria]["input_date(1i)"]
        @search_date = params[:criteria]["input_date(1i)"] + "-" + params[:criteria]["input_date(2i)"] + "-" + params[:criteria]["input_date(3i)"]
      else
        @search_date = Date.today.to_s
      end
    @search = MaterialInput.search(params[:search])
    @material_inputs = @search.all(:conditions => ["input_date = ?", @search_date]).paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @material_inputs }
    end
  end

  # GET /material_inputs/1
  # GET /material_inputs/1.xml
  def show
    @material_input = MaterialInput.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @material_input }
    end
  end

  # GET /material_inputs/new
  # GET /material_inputs/new.xml
  def new
    @material_input = MaterialInput.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @material_input }
    end
  end

  # GET /material_inputs/1/edit
  def edit
    @material_input = MaterialInput.find(params[:id])
  end

  # POST /material_inputs
  # POST /material_inputs.xml
  def create
    @material_input = MaterialInput.new(params[:material_input])
    @material_input.input_date = get_the_actual_date
    respond_to do |format|
      if @material_input.save
        flash[:notice] = 'MaterialInput was successfully created.'
        format.html { redirect_to(@material_input) }
        format.xml  { render :xml => @material_input, :status => :created, :location => @material_input }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @material_input.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /material_inputs/1
  # PUT /material_inputs/1.xml
  def update
    @material_input = MaterialInput.find(params[:id])

    respond_to do |format|
      if @material_input.update_attributes(params[:material_input])
        flash[:notice] = 'MaterialInput was successfully updated.'
        format.html { redirect_to(@material_input) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @material_input.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /material_inputs/1
  # DELETE /material_inputs/1.xml
  def destroy
    @material_input = MaterialInput.find(params[:id])
    @material_input.destroy

    respond_to do |format|
      format.html { redirect_to(material_inputs_url) }
      format.xml  { head :ok }
    end
  end
  
  def attach_machines
    @material_input = MaterialInput.find(params[:id])
    @machines = Machine.all(:order => "machine_number")
  end
  
  def add_machines
    @material_input = MaterialInput.find(params[:id])
  
    params[:machine].each {|machine_id, content|
    machine = Machine.find(machine_id)
           
       if @material_input.input_machines.first(:conditions => ["machine_id = ?", machine])
          flash[:error] ? flash[:error] << "Machine " + machine.machine_number +  " has already attached<br />" : flash[:error] = "Machine " + machine.machine_number +  " has already attached <br />" 
       else
          @material_input.input_machines.create(:machine_id => machine.id)
          flash[:notice] ? flash[:notice] << "Machine " + machine.machine_number + " has successfully attached <br /> " : flash[:notice] = "Machine " + machine.machine_number + " has successfully attached <br /> "
       end
      
     
    }
    redirect_to(attach_machines_material_input_path(@material_input))
  end
  
  def remove_machine
    @material_input = MaterialInput.find(params[:id])
    machine = Machine.find(params[:machine_id])
    input_machine = @material_input.input_machines.find(machine.id)
    input_machine.destroy
    flash[:notice] = "Machine " + machine.machine_number + " successfully remove"
    redirect_to(attach_machines_material_input_path(@material_input))
  end
  
end
