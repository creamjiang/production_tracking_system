class PrmsExportsController < ApplicationController
  before_filter :authenticate_admin
  # GET /prms_exports
  # GET /prms_exports.xml
  def index
    @prms_exports = PrmsExport.all(:order => "created_at DESC").paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erbe => params
      format.xml  { render :xml => @prms_exports }
    end
  end

  # GET /prms_exports/1
  # GET /prms_exports/1.xml
  def show
    @prms_export = PrmsExport.find(params[:id])
    @items = @prms_export.export_items
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @prms_export }
    end
  end

  # GET /prms_exports/new
  # GET /prms_exports/new.xml
  def new
    if PrmsExport.first(:conditions => "posted = false")
      flash[:error] = "You have unposted Prms record, please post it first"
      redirect_to :action => "index"
    else
      @prms_export = PrmsExport.new
      @stocks = current_user.stocks
    end
    
   
  end

  # GET /prms_exports/1/edit
  def edit
    @prms_export = PrmsExport.find(params[:id])
  end

  # POST /prms_exports
  # POST /prms_exports.xml
  def create
    @prms_export = PrmsExport.new(params[:prms_export])

      if params[:procedure]
        if @prms_export.save!
          @prms_export.import_items(params[:procedure])
          redirect_to(@prms_export, :notice => 'Prms Export was successfully created.')
        else
            flash[:error] = "You dont have valid quantity input."
            redirect_to :action => "new" 
        end
      else
        flash[:error] = "You dont have any valid quantity input."
        redirect_to :action => "new"
      end
  end

  # PUT /prms_exports/1
  # PUT /prms_exports/1.xml
  def update
    @prms_export = PrmsExport.find(params[:id])

    respond_to do |format|
      if @prms_export.update_attributes(params[:prms_export])
        format.html { redirect_to(@prms_export, :notice => 'PrmsExport was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prms_export.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /prms_exports/1
  # DELETE /prms_exports/1.xml
  def destroy
    @prms_export = PrmsExport.find(params[:id])
    if @prms_export.verify_destroy
      flash[:notice] = "PRMS export has been deleted"
    else
      flash[:error] = "You cannot delete the PRMS which already been posted"
    end

    respond_to do |format|
      format.html { redirect_to(prms_exports_url) }
      format.xml  { head :ok }
    end
  end

  def update_items
    @prms_export = PrmsExport.find(params[:id])
    @prms_export.update_item(params[:procedure])
    flash[:notice] = 'Items was successfully updated.'
    redirect_to(@prms_export)
  end

  def post_items
    @prms_export = PrmsExport.find(params[:id])
    if @prms_export.generate_file(current_user)
      flash[:notice] = 'Items was successfully posted.'
    else
      flash[:error] = 'You have invalid item quantity.'
    end
    redirect_to(@prms_export)
  end

  def sources
    @item = ExportItem.find(params[:id])
    @sources = FlushAccount.all(:conditions => ["export_item_id = ?", @item.id], :joins => :procedure_transaction)
    @total = @sources.inject(0) {|sum, i| sum += i.quantity}
    @sources = @sources.paginate(:page => params[:page], :per_page => 50)
    render :layout => false
  end

  def download
    @prms_export = PrmsExport.find(params[:id])
    begin
      unless is_ict_admin?
        if @prms_export.disabled?
          flash[:error] = "The download line already disabled to user"
          redirect_to :action => "index"
        else
          @prms_export.disabled = true
          @prms_export.save!
          path = filter_filename(@prms_export.document.url)
          send_file path, :type=>"text/plain ",  :disposition => 'attachment' #:x_sendfile=>true#
          #send_data path, :type => @prms_export.document_content_type, :disposition => 'attachment'
        end
      else
        path = filter_filename(@prms_export.document.url)
        #send_data path, :type => @prms_export.document_content_type, :disposition => 'attachment'
        send_file path, :type=>"text/plain ", :disposition => 'attachment'
      end
    rescue
      flash[:error] = "error reading file"
      redirect_to :action => "index"
    end
  end

  private

  def filter_filename(file_name)
    result = file_name.split("?")
    Rails.root.to_s + "/public" + result[0]
  end
end
