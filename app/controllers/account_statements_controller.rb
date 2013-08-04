class AccountStatementsController < ApplicationController
  before_filter :authenticate_admin
  # GET /account_statements
  # GET /account_statements.xml
  def index
    @account_statements = AccountStatement.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @account_statements }
    end
  end

  # GET /account_statements/1
  # GET /account_statements/1.xml
  def show
    @account_statement = AccountStatement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account_statement }
    end
  end

  # GET /account_statements/new
  # GET /account_statements/new.xml
  def new
    @account_statement = AccountStatement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account_statement }
    end
  end

  # GET /account_statements/1/edit
  def edit
    @account_statement = AccountStatement.find(params[:id])
  end

  # POST /account_statements
  # POST /account_statements.xml
  def create
    @account_statement = AccountStatement.new(params[:account_statement])

    respond_to do |format|
      if @account_statement.save
        format.html { redirect_to(@account_statement, :notice => 'AccountStatement was successfully created.') }
        format.xml  { render :xml => @account_statement, :status => :created, :location => @account_statement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account_statement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /account_statements/1
  # PUT /account_statements/1.xml
  def update
    @account_statement = AccountStatement.find(params[:id])

    respond_to do |format|
      if @account_statement.update_attributes(params[:account_statement])
        format.html { redirect_to(@account_statement, :notice => 'AccountStatement was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account_statement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /account_statements/1
  # DELETE /account_statements/1.xml
  def destroy
    @account_statement = AccountStatement.find(params[:id])
    @account_statement.destroy

    respond_to do |format|
      format.html { redirect_to(account_statements_url) }
      format.xml  { head :ok }
    end
  end
end
