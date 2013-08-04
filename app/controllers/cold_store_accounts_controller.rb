class ColdStoreAccountsController < ApplicationController
  before_filter :authenticate_admin
  # GET /cold_store_accounts
  # GET /cold_store_accounts.xml
  def index
    @cold_store_accounts = ColdStoreAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cold_store_accounts }
    end
  end

  # GET /cold_store_accounts/1
  # GET /cold_store_accounts/1.xml
  def show
    @cold_store_account = ColdStoreAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cold_store_account }
    end
  end

  # GET /cold_store_accounts/new
  # GET /cold_store_accounts/new.xml
  def new
    @cold_store_account = ColdStoreAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cold_store_account }
    end
  end

  # GET /cold_store_accounts/1/edit
  def edit
    @cold_store_account = ColdStoreAccount.find(params[:id])
  end

  # POST /cold_store_accounts
  # POST /cold_store_accounts.xml
  def create
    @cold_store_account = ColdStoreAccount.new(params[:cold_store_account])

    respond_to do |format|
      if @cold_store_account.save
        flash[:notice] = 'ColdStoreAccount was successfully created.'
        format.html { redirect_to(@cold_store_account) }
        format.xml  { render :xml => @cold_store_account, :status => :created, :location => @cold_store_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cold_store_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cold_store_accounts/1
  # PUT /cold_store_accounts/1.xml
  def update
    @cold_store_account = ColdStoreAccount.find(params[:id])

    respond_to do |format|
      if @cold_store_account.update_attributes(params[:cold_store_account])
        flash[:notice] = 'ColdStoreAccount was successfully updated.'
        format.html { redirect_to(@cold_store_account) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cold_store_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cold_store_accounts/1
  # DELETE /cold_store_accounts/1.xml
  def destroy
    @cold_store_account = ColdStoreAccount.find(params[:id])
    @cold_store_account.destroy

    respond_to do |format|
      format.html { redirect_to(cold_store_accounts_url) }
      format.xml  { head :ok }
    end
  end
end
