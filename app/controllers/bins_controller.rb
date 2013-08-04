class BinsController < ApplicationController
  
  before_filter :authenticate_user
  # GET /bins
  # GET /bins.xml
  def index
    @search = Bin.search(params[:search])
    @bins = @search.all.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bins }
    end
  end

  # GET /bins/1
  # GET /bins/1.xml
  def show
    @bin = Bin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bin }
    end
  end

  # GET /bins/new
  # GET /bins/new.xml
  def new
    @bin = Bin.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bin }
    end
  end

  # GET /bins/1/edit
  def edit
    @bin = Bin.find(params[:id])
  end

  # POST /bins
  # POST /bins.xml
  def create
    @bin = Bin.new(params[:bin])

    respond_to do |format|
      if @bin.save
        flash[:notice] = 'Bin was successfully created.'
        format.html { redirect_to(@bin) }
        format.xml  { render :xml => @bin, :status => :created, :location => @bin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bins/1
  # PUT /bins/1.xml
  def update
    @bin = Bin.find(params[:id])
    @bin.bin_status_id = params[:bin][:bin_status_id]

    respond_to do |format|
      if @bin.update_attributes(params[:bin])
        flash[:notice] = 'Bin was successfully updated.'
        format.html { redirect_to(@bin) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bins/1
  # DELETE /bins/1.xml
  def destroy
    @bin = Bin.find(params[:id])
    if @bin.verify_for_destroy
      flash[:notice] = "Deleted successfully"
    else
      flash[:error] = "Cannot delete the bin because it's in use"
    end
    

    respond_to do |format|
      format.html { redirect_to(bins_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def list_bin_types
    @bin_types = current_user.belonging_bin_types
  end
  
  def list_full
    bin_type = BinType.find(params[:id])
    @bins = Bin.full(bin_type)
  end
  
  def clearing_bin
    bin = Bin.find_by_bin_number(params[:bin_number])
    if bin
      if bin.bin_status_id == BinStatus::FULL
        bin.clear_bin(current_user_id)
        flash[:notice] = "The bin has been cleared"
        redirect_to_clear_bin_method
      else
        flash[:error] = "The bin is not full or not being used"
        redirect_to_clear_bin_method
      end
    else
      flash[:error] = "Cannot find the bin"
      redirect_to_clear_bin_method
    end
  end
  
  
  private
  
   def redirect_to_clear_bin_method
    setting = Setting.first
    if setting.register_bin_with_scanner
      redirect_to clear_bins_path
    else
      redirect_to list_bin_types_bins_path 
    end
  end
  
  
  
end
