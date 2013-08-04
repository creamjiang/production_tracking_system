class RejectCodesController < ApplicationController
  
  before_filter :authenticate_admin
  #protect_from_forgery :except => :search

  # GET /reject_codes
  # GET /reject_codes.xml
  def index
    @routing_processes = RoutingProcess.all
    @search = RejectCode.search(params[:search])
    @reject_codes = @search.all(:order => "routing_process_id, code", :joins => :routing_process).paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html# index.html.erb
      format.xml  { render :xml => @reject_codes }
          
    end
  end
  

  # GET /reject_codes/1
  # GET /reject_codes/1.xml
  def show
    @reject_code = RejectCode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reject_code }
    end
  end

  # GET /reject_codes/new
  # GET /reject_codes/new.xml
  def new
    @reject_code = RejectCode.new
    1.upto(3) { @reject_code.photos.build }
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reject_code }
    end
  end

  # GET /reject_codes/1/edit
  def edit
    @reject_code = RejectCode.find(params[:id])
    if @reject_code.photos.first.nil?
       1.upto(3) { @reject_code.photos.build }
    end

  end

  # POST /reject_codes
  # POST /reject_codes.xml
  def create
    @reject_code = RejectCode.new(params[:reject_code])

    respond_to do |format|
      if @reject_code.save
        flash[:notice] = 'RejectCode was successfully created.'
        format.html { redirect_to(@reject_code) }
        format.xml  { render :xml => @reject_code, :status => :created, :location => @reject_code }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reject_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reject_codes/1
  # PUT /reject_codes/1.xml
  def update
    params[:photo_ids] ||= []
    @reject_code = RejectCode.find(params[:id])
    
    unless params[:photo_ids].empty?
      Photo.destroy_pics(params[:id], params[:photo_ids])
    end

    respond_to do |format|
      if @reject_code.update_attributes(params[:reject_code])
        flash[:notice] = 'RejectCode was successfully updated.'
        format.html { redirect_to(@reject_code) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reject_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reject_codes/1
  # DELETE /reject_codes/1.xml
  def destroy
    @reject_code = RejectCode.find(params[:id])
    @reject_code.destroy

    respond_to do |format|
      format.html { redirect_to(reject_codes_url) }
      format.xml  { head :ok }
    end
  end
end
