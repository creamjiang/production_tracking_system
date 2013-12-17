class ProcedureTransactionsController < ApplicationController
  
  before_filter :authenticate_admin
  # GET /procedure_transactions
  # GET /procedure_transactions.xml
  def index
    @search = ProcedureTransaction.search(params[:search])
     #  if params[:created_at]
     #    if params[:created_at].blank?
     #      session[:date] = nil
     #    else
     #      session[:date] = Date.parse(params[:created_at]).strftime("%Y-%m-%d")
     #    end
     #  end
     # if params[:search]
     #   if session[:date]
     #     @procedure_transactions = @search.all(:include => [:employee, :product, :machine, :bin, :bin_type], :conditions => ["transaction_date = ?", session[:date]]).paginate(:page => params[:page], :per_page => 50)
     #   else
     #     @procedure_transactions = @search.all(:include => [:employee, :product, :machine, :bin, :bin_type]).paginate(:page => params[:page], :per_page => 50)
     #   end
     # else
     #   @procedure_transactions = []
     # end
    @procedure_transactions = @search.all(:include => [:employee, :product, :machine, :bin, :bin_type]).paginate(:page => params[:page], :per_page => 50)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @procedure_transactions }
    end
  end

  # GET /procedure_transactions/1
  # GET /procedure_transactions/1.xml
  def show
    @procedure_transaction = ProcedureTransaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @procedure_transaction }
    end
  end

  # GET /procedure_transactions/new
  # GET /procedure_transactions/new.xml
#  def new
#    @procedure_transaction = ProcedureTransaction.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @procedure_transaction }
#    end
#  end

  # GET /procedure_transactions/1/edit
#  def edit
#    @procedure_transaction = ProcedureTransaction.find(params[:id])
#  end

  # POST /procedure_transactions
  # POST /procedure_transactions.xml
#  def create
#    @procedure_transaction = ProcedureTransaction.new(params[:procedure_transaction])
#
#    respond_to do |format|
#      if @procedure_transaction.save
#        flash[:notice] = 'ProcedureTransaction was successfully created.'
#        format.html { redirect_to(@procedure_transaction) }
#        format.xml  { render :xml => @procedure_transaction, :status => :created, :location => @procedure_transaction }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @procedure_transaction.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /procedure_transactions/1
  # PUT /procedure_transactions/1.xml
#  def update
#    @procedure_transaction = ProcedureTransaction.find(params[:id])
#
#    respond_to do |format|
#      if @procedure_transaction.update_attributes(params[:procedure_transaction])
#        flash[:notice] = 'ProcedureTransaction was successfully updated.'
#        format.html { redirect_to(@procedure_transaction) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @procedure_transaction.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /procedure_transactions/1
  # DELETE /procedure_transactions/1.xml
#  def destroy
#    @procedure_transaction = ProcedureTransaction.find(params[:id])
#    @procedure_transaction.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(procedure_transactions_url) }
#      format.xml  { head :ok }
#    end
#  end
end
