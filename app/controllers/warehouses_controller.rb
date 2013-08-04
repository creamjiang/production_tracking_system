class WarehousesController < ApplicationController
  before_filter :authenticate_admin
  # GET /warehouses
  # GET /warehouses.xml
  def index
    @warehouses = Warehouse.paginate(:page => params[:page], :per_page => 50)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @warehouses }
    end
  end

  # GET /warehouses/1
  # GET /warehouses/1.xml
  def show
    @warehouse = Warehouse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @warehouse }
    end
  end

  # GET /warehouses/new
  # GET /warehouses/new.xml
  def new
    @warehouse = Warehouse.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @warehouse }
    end
  end

  # GET /warehouses/1/edit
  def edit
    @warehouse = Warehouse.find(params[:id])
  end

  # POST /warehouses
  # POST /warehouses.xml
  def create
    @warehouse = Warehouse.new(params[:warehouse])

    respond_to do |format|
      if @warehouse.save
        format.html { redirect_to(@warehouse, :notice => 'Warehouse was successfully created.') }
        format.xml  { render :xml => @warehouse, :status => :created, :location => @warehouse }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @warehouse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /warehouses/1
  # PUT /warehouses/1.xml
  def update
    @warehouse = Warehouse.find(params[:id])

    respond_to do |format|
      if @warehouse.update_attributes(params[:warehouse])
        format.html { redirect_to(@warehouse, :notice => 'Warehouse was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @warehouse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /warehouses/1
  # DELETE /warehouses/1.xml
  def destroy
    @warehouse = Warehouse.find(params[:id])
    @warehouse.destroy

    respond_to do |format|
      format.html { redirect_to(warehouses_url) }
      format.xml  { head :ok }
    end
  end

  def remove_item
    @warehouse = Warehouse.find(params[:id])
    params[:item] ||= []
    params[:item].each do |item_id, content|
      item = @warehouse.destinations.find(item_id) if content[:selected].to_i == 1
      item.destroy
    end
    flash[:notice] = "Operation Completed"
    redirect_to @warehouse
  end

  def add_item
    @warehouse = Warehouse.find(params[:id])
    item = @warehouse.destinations.new(params[:item])
    if item.save
      flash[:notice] = "Operation Completed"
    else
      flash[:error] = ""
      item.errors.each {|key, content| flash[:error] << content << "<br/>"}
    end

    redirect_to @warehouse
  end

  def assign
    @warehouses = Warehouse.options
    @search = RoutineProduct.search(params[:search])
    @routine_products = @search.all(:joins => [:routing_procedure, :product], :order => "products.part_number").paginate(:page => params[:page], :per_page => 50)
  end

  def routine_product
    @search = Product.search(params[:search])
    @products = @search.all(:include => :category, :order => "part_number")
    @procedures = RoutingProcedure.options
    @warehouses = Warehouse.options
  end

  def add_routine_product
    if params[:routing_procedure_id].to_i == 0
      flash[:error] = "You must choose a routing procedure to proceed"
    else
      params[:product] ||= []
      procedure_id = params[:routing_procedure_id].to_i
      params[:product].each {|product_id, content|
       if content[:selected]
         #pro = Product.find(product_id)
         unless RoutineProduct.first(:conditions => ["product_id = ? and routing_procedure_id = ?", product_id.to_i, procedure_id.to_i])
           rp = RoutineProduct.new(:routing_procedure_id => procedure_id, :product_id => product_id)
           rp.warehouse_id = content[:warehouse_id]
#           if content[:include_reject]
#             rp.reject_include = true
#           else
#             rp.reject_include = false
#           end
           rp.save!
         end
        end
        }

    end
    redirect_to :action => "assign"
  end

  def update_procedure
    params[:item] ||= []
    params[:item].each do |item_id, content|
      pro = RoutineProduct.find(item_id.to_i)
      if content[:remove]
        pro.destroy if pro
      else

        pro.warehouse_id = content[:warehouse_id].to_i
        if content[:include_reject]
          pro.reject_include = true
        else
          pro.reject_include = false
        end
        pro.save!
      end
    end
    flash[:notice] = "Operation Completed"
    redirect_to :action => "assign"
  end

end
