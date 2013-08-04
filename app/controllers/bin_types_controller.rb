class BinTypesController < ApplicationController
  
  before_filter :authenticate_admin
  # GET /bin_types
  # GET /bin_types.xml
  def index
    @bin_types = BinType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bin_types }
    end
  end

  # GET /bin_types/1
  # GET /bin_types/1.xml
  def show
    @bin_type = BinType.find(params[:id])
    
    @containers = @bin_type.containers
    @search = Product.search(params[:search])
    products = @search.all(:order => "part_number")
    @products = @bin_type.exception_products(products)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bin_type }
    end
  end

  # GET /bin_types/new
  # GET /bin_types/new.xml
  def new
    @bin_type = BinType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bin_type }
    end
  end

  # GET /bin_types/1/edit
  def edit
    @bin_type = BinType.find(params[:id])
  end

  # POST /bin_types
  # POST /bin_types.xml
  def create
    @bin_type = BinType.new(params[:bin_type])

    respond_to do |format|
      if @bin_type.save
        flash[:notice] = 'BinType was successfully created.'
        format.html { redirect_to(@bin_type) }
        format.xml  { render :xml => @bin_type, :status => :created, :location => @bin_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bin_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bin_types/1
  # PUT /bin_types/1.xml
  def update
    @bin_type = BinType.find(params[:id])

    respond_to do |format|
      if @bin_type.update_attributes(params[:bin_type])
        flash[:notice] = 'BinType was successfully updated.'
        format.html { redirect_to(@bin_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bin_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bin_types/1
  # DELETE /bin_types/1.xml
  def destroy
    @bin_type = BinType.find(params[:id])
    if @bin_type.verify_for_destroy
    
     flash[:notice] = "Deleted successfully"
    else
     flash[:error] = "Cannot delete the bin type because it belongs to some bin"
    end

    respond_to do |format|
      format.html { redirect_to(bin_types_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_bin_type_product
    @bin_type = BinType.find(params[:id])
    params[:product].each do |product_id, selected|
      unless @bin_type.containers.first(:conditions => ["product_id = ?", product_id.to_i])
        @bin_type.containers.create(:product_id => product_id.to_i)
      end
    end
    
    flash[:notice] = "Product has been successfully added"
    redirect_to(@bin_type)
  end
  
  def remove_product
    @bin_type = BinType.find(params[:id])
    @bin_type.containers.find(params[:container_id]).destroy
    flash[:notice] = "Successfully removed"
    redirect_to(@bin_type)
  end
  
  def update_loading
    @bin_type = BinType.find(params[:id])
    params[:container].each do |container_id, content|
      container = Container.find(container_id)
      container.update_attributes(:maximum_load => content[:quantity].to_i) if container
    end
    flash[:notice] = "Update successfully"
    redirect_to(@bin_type)
  end
  
  
end
