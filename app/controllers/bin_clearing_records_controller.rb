class BinClearingRecordsController < ApplicationController
 
  before_filter :authenticate_user
  # GET /bin_clearing_records
  # GET /bin_clearing_records.xml
  def index
    @search = BinClearingRecord.search(params[:search])
    @bin_clearing_records = @search.all.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bin_clearing_records }
    end
  end

  # GET /bin_clearing_records/1
  # GET /bin_clearing_records/1.xml
  def show
    @bin_clearing_record = BinClearingRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bin_clearing_record }
    end
  end

  # GET /bin_clearing_records/new
  # GET /bin_clearing_records/new.xml
#  def new
#    @bin_clearing_record = BinClearingRecord.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @bin_clearing_record }
#    end
#  end

  # GET /bin_clearing_records/1/edit
#  def edit
#    @bin_clearing_record = BinClearingRecord.find(params[:id])
#  end

  # POST /bin_clearing_records
  # POST /bin_clearing_records.xml
#  def create
#    @bin_clearing_record = BinClearingRecord.new(params[:bin_clearing_record])
#
#    respond_to do |format|
#      if @bin_clearing_record.save
#        flash[:notice] = 'BinClearingRecord was successfully created.'
#        format.html { redirect_to(@bin_clearing_record) }
#        format.xml  { render :xml => @bin_clearing_record, :status => :created, :location => @bin_clearing_record }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @bin_clearing_record.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /bin_clearing_records/1
  # PUT /bin_clearing_records/1.xml
#  def update
#    @bin_clearing_record = BinClearingRecord.find(params[:id])
#
#    respond_to do |format|
#      if @bin_clearing_record.update_attributes(params[:bin_clearing_record])
#        flash[:notice] = 'BinClearingRecord was successfully updated.'
#        format.html { redirect_to(@bin_clearing_record) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @bin_clearing_record.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /bin_clearing_records/1
  # DELETE /bin_clearing_records/1.xml
#  def destroy
#    @bin_clearing_record = BinClearingRecord.find(params[:id])
#    @bin_clearing_record.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(bin_clearing_records_url) }
#      format.xml  { head :ok }
#    end
#  end
end
