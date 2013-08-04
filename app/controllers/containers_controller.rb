class ContainersController < ApplicationController
  
  before_filter :authenticate_admin
  # GET /containers
  # GET /containers.xml
  def index
    @containers = Container.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @containers }
    end
  end

  # GET /containers/1
  # GET /containers/1.xml
  def show
    @container = Container.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @container }
    end
  end

  # GET /containers/new
  # GET /containers/new.xml
  def new
    @container = Container.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @container }
    end
  end

  # GET /containers/1/edit
  def edit
    @container = Container.find(params[:id])
  end

  # POST /containers
  # POST /containers.xml
  def create
    @container = Container.new(params[:container])

    respond_to do |format|
      if @container.save
        flash[:notice] = 'Container was successfully created.'
        format.html { redirect_to(@container) }
        format.xml  { render :xml => @container, :status => :created, :location => @container }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @container.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /containers/1
  # PUT /containers/1.xml
  def update
    @container = Container.find(params[:id])

    respond_to do |format|
      if @container.update_attributes(params[:container])
        flash[:notice] = 'Container was successfully updated.'
        format.html { redirect_to(@container) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @container.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /containers/1
  # DELETE /containers/1.xml
  def destroy
    @container = Container.find(params[:id])
    if @container.verify_for_destroy
      flash[:notice] = "Deleted successfully"
    else
      flash[:error] = "Cannot delete the container because it's in use"
    end

    respond_to do |format|
      format.html { redirect_to(containers_url) }
      format.xml  { head :ok }
    end
  end
end
