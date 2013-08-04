class BinStatusesController < ApplicationController
  
  before_filter :authenticate_admin
  # GET /bin_statuses
  # GET /bin_statuses.xml
  def index
    @bin_statuses = BinStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bin_statuses }
    end
  end

  # GET /bin_statuses/1
  # GET /bin_statuses/1.xml
  def show
    @bin_status = BinStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bin_status }
    end
  end

  # GET /bin_statuses/new
  # GET /bin_statuses/new.xml
#  def new
#    @bin_status = BinStatus.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @bin_status }
#    end
#  end

  # GET /bin_statuses/1/edit
#  def edit
#    @bin_status = BinStatus.find(params[:id])
#  end

  # POST /bin_statuses
  # POST /bin_statuses.xml
#  def create
#    @bin_status = BinStatus.new(params[:bin_status])
#
#    respond_to do |format|
#      if @bin_status.save
#        flash[:notice] = 'BinStatus was successfully created.'
#        format.html { redirect_to(@bin_status) }
#        format.xml  { render :xml => @bin_status, :status => :created, :location => @bin_status }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @bin_status.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /bin_statuses/1
  # PUT /bin_statuses/1.xml
#  def update
#    @bin_status = BinStatus.find(params[:id])
#
#    respond_to do |format|
#      if @bin_status.update_attributes(params[:bin_status])
#        flash[:notice] = 'BinStatus was successfully updated.'
#        format.html { redirect_to(@bin_status) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @bin_status.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /bin_statuses/1
  # DELETE /bin_statuses/1.xml
#  def destroy
#    @bin_status = BinStatus.find(params[:id])
#    @bin_status.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(bin_statuses_url) }
#      format.xml  { head :ok }
#    end
#  end
end
