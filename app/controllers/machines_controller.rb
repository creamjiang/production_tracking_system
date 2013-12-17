class MachinesController < ApplicationController
  
  before_filter :authenticate_user
  # GET /machines
  # GET /machines.xml
  def index
    @search = Machine.search(params[:search])
    if is_ict_admin?

      @machines = @search.all(:order => "machine_number").paginate(:page => params[:page], :per_page => 50)
    elsif is_supervisor?
      @search = Machine.search(params[:search])
      @machines = current_user.belongs_machines(@search.all)
      @machines = @machines.paginate(:page => params[:page], :per_page => 30)
    elsif is_application_admin?
      @machines = current_user.belongs_machines(@search.all)
      @machines = @machines.paginate(:page => params[:page], :per_page => 30)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @machines }
    end
  end

  # GET /machines/1
  # GET /machines/1.xml
  def show
    @machine = Machine.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @machine }
    end
  end

  # GET /machines/new
  # GET /machines/new.xml
  def new
    if is_ict_admin?
      @machine = Machine.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @machine }
      end
    end
  end

  # GET /machines/1/edit
  def edit
    if is_ict_admin?
      @machine = Machine.find(params[:id])
    end
  end

  # POST /machines
  # POST /machines.xml
  def create
    if is_admin?
      @machine = Machine.new(params[:machine])
  
      respond_to do |format|
        if @machine.save
          flash[:notice] = 'Machine was successfully created.'
          format.html { redirect_to(@machine) }
          format.xml  { render :xml => @machine, :status => :created, :location => @machine }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @machine.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /machines/1
  # PUT /machines/1.xml
  def update
    @machine = Machine.find(params[:id])

    respond_to do |format|
      if @machine.update_attributes(params[:machine])
        flash[:notice] = 'Machine was successfully updated.'
        format.html { redirect_to(@machine) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @machine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /machines/1
  # DELETE /machines/1.xml
  def destroy
    if is_admin?
      @machine = Machine.find(params[:id])
  
      if @machine.verify_for_destroy
        flash[:notice] = "Deleted successfully"
      else
        flash[:error] = "Cannot delete the machine because it's in use"
      end
  
      respond_to do |format|
        format.html { redirect_to(machines_url) }
        format.xml  { head :ok }
      end
    end
  end
  
  def attach_employee
    @machine = Machine.find(params[:id])
    @employees = @machine.exception_employees #Employee.all(:include => :department, :order => "employee_number")
  end
  
  def attach_product
    @machine = Machine.find(params[:id])
    #@products = Product.all(:include => :category, :order => "part_number")
    @search = Product.search(params[:search])
    products = @search.all(:include => :category, :order => "part_number")
    @products = @machine.exception_products(products)
    @procedures = RoutingProcedure.options

    #@warehouses = Warehouse.options
    @bin_types = BinType.all(:order => "name")
  end
  
  
  def add_operator
    machine = Machine.find(params[:id])
    
    params[:employee] ||= []
    
    params[:employee].each {|emp_id, content|
     emp = Employee.find(emp_id)
     unless Operator.first(:conditions => ["employee_id = ? and machine_id = ?", emp.id, machine.id])
      
       Operator.create(:machine_id => machine.id, :employee_id => emp.id)
       
     end if emp
     
    }
    flash[:notice] = "Operation Completed"
    redirect_to(attach_employee_machine_path(machine))
  end
  
  def add_product
    machine = Machine.find(params[:id])
    
    params[:product] ||= []
    
    params[:product].each {|product_id, content|
     pro = Product.find(product_id)
     unless AttachedProduct.first(:conditions => ["product_id = ? and machine_id = ?", pro.id, machine.id])
       AttachedProduct.create(:machine_id => machine.id, :product_id => pro.id)
     end if pro
    }

    flash[:notice] = "Operation Completed"
    redirect_to(attach_product_machine_path(machine))
  end
  
  def remove_employee
    
    machine = Machine.find(params[:id])
    params[:employee] ||= []
    
    params[:employee].each {|emp_id, content|
     
     operator = machine.operators.first(:conditions => ["employee_id = ?", emp_id.to_i])   
     operator.destroy if operator
     
    }
    
    flash[:notice] = "successfully remove from the machine operator"
    redirect_to(attach_employee_machine_path(machine))
  end
  
  def remove_product
    machine = Machine.find(params[:id])
    attached_machine = machine.attached_products.find(params[:product_id].to_i)
    product = Product.find(attached_machine.product_id)
    
    attached_machine.destroy if attached_machine
    flash[:notice] = product.part_name + " successfully remove from the machine operator"
    redirect_to(attach_product_machine_path(machine))
  end
  
  def update_visible
    machine = Machine.find(params[:id])
    
    if params[:activated]
      activated_ids = params[:activated].collect {|id| id.to_i}
    else
      activated_ids = []
    end

    seen_ids = params[:seen].collect {|id| id.to_i} if params[:seen]
   
    seen_ids.each do |id|
      r = machine.attached_products.find(id)
      if activated_ids.include?(id)
        r.visible = true
      else
        r.visible = false
      end
      r.save
    end

    params[:attached_product] ||= []
    params[:attached_product].each do |ap_id, content|
      found = AttachedProduct.find(ap_id)
      found.routing_procedure_id = content[:routing_procedure_id].to_i
      found.bin_type_id = content[:bin_type_id].to_i
#      found.warehouse_id = content[:warehouse_id].to_i
#      if content[:include_reject]
#        found.reject_include =  true
#      else
#        found.reject_include =  false
#      end
      found.save!
    end
    
    flash[:notice] = "Visible machines Updated"
    redirect_to(attach_product_machine_path(machine))
  end
  
  
  def attach_shift
    @machine = Machine.find(params[:id])
    @shifts = @machine.exception_shifts #Shift.all(:order => "name")
  end
  
  def add_shift
    machine = Machine.find(params[:id])
    
    params[:shift] ||= []
    
    params[:shift].each {|shift_id, content|
     s = Shift.find(shift_id)
     unless machine.shift_items.first(:conditions => ["shift_id = ?", s.id])
       machine.shift_items.create(:shift_id => s.id)
       
     end if s
     
    }
    flash[:notice] = "Shift(s) has successfully attached to a machine " 
    redirect_to(attach_shift_machine_path(machine))
  end
  
  def remove_shift
    machine = Machine.find(params[:id])
    
    params[:shift] ||= []
    
    params[:shift].each {|shift_id, content|
     
     attached_shift = machine.shift_items.first(:conditions => ["shift_id = ?", shift_id.to_i])
     attached_shift.destroy if attached_shift 
    }
    
    flash[:notice] = "Shift successfully remove from the machine"
    redirect_to(attach_shift_machine_path(machine))
  end
  
  def process_info
    @machine = Machine.find(params[:id])
    @processes = @machine.swapable_processes
  end
  
  def update_process
    @machine = Machine.find(params[:id])
    set = RoutingProcedure.find_by_routing_process_id(params[:process_id].to_i)
    m = @machine.procedure_machine
    m.routing_procedure_id = set.id
    m.save!
    flash[:notice] = "Update Successfully"
    redirect_to(@machine)
  end

  def update_process_info

    params[:machine] ||= []

    params[:machine].each do |m_id, content|
      machine = Machine.find(m_id.to_i)
      set = RoutingProcedure.find_by_routing_process_id(content[:process_id].to_i)
      m = machine.procedure_machine
      m.routing_procedure_id = set.id
      m.save!
    end

    flash[:notice] = "Update Successfully"
    redirect_to(machines_url)
  end
  
end
