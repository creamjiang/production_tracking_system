class EfficiencySchedulesController < ApplicationController
  before_filter :authenticate_admin
  # GET /efficiency_schedules
  # GET /efficiency_schedules.xml
  def index
    @attach_products = current_user.routing_procedures_products
    @search = EfficiencySchedule.search(params[:search])
    @efficiency_schedules = @search.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @efficiency_schedules }
    end
  end

  # GET /efficiency_schedules/1
  # GET /efficiency_schedules/1.xml
  def show
    @efficiency_schedule = EfficiencySchedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @efficiency_schedule }
    end
  end

  # GET /efficiency_schedules/new
  # GET /efficiency_schedules/new.xml
  def new
    @efficiency_schedule = EfficiencySchedule.new
    @attach_products = current_user.routing_procedures_products
    @reasons = []
  end

  def search_reasons
    @attached_product = AttachedProduct.find(params[:id]) rescue nil
    if @attached_product
      @reasons = @attached_product.routing_process.machine_down_reasons
    else
      @reasons = []
    end
    render :update do |page|
      page.replace_html 'down_reasons', :partial => 'down_reasons', :locals => {:reasons => @reasons}
    end
  end

  # GET /efficiency_schedules/1/edit
#  def edit
#    @efficiency_schedule = EfficiencySchedule.find(params[:id])
#  end

  # POST /efficiency_schedules
  # POST /efficiency_schedules.xml
  def create
    @efficiency_schedule = EfficiencySchedule.new(params[:efficiency_schedule])

    respond_to do |format|
      if @efficiency_schedule.save
        format.html { redirect_to(@efficiency_schedule, :notice => 'EfficiencySchedule was successfully created.') }
        format.xml  { render :xml => @efficiency_schedule, :status => :created, :location => @efficiency_schedule }
      else
        format.html {
          @attach_products = current_user.routing_procedures_products
          @attached_product = AttachedProduct.find(params[:attached_product_id]) rescue nil
          if @attached_product
            @reasons = @attached_product.routing_process.machine_down_reasons
          else
            @reasons = []
          end
          render :action => "new" }
        format.xml  { render :xml => @efficiency_schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /efficiency_schedules/1
  # PUT /efficiency_schedules/1.xml
  def update
    @efficiency_schedule = EfficiencySchedule.find(params[:id])

    respond_to do |format|
      if @efficiency_schedule.update_attributes(params[:efficiency_schedule])
        format.html { redirect_to(@efficiency_schedule, :notice => 'EfficiencySchedule was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html {
          @attach_products = current_user.routing_procedures_products
          @attached_product = AttachedProduct.find(params[:attached_product_id]) rescue nil
          if @attached_product
            @reasons = @attached_product.routing_process.machine_down_reasons
          else
            @reasons = []
          end
          render :action => "edit" }
        format.xml  { render :xml => @efficiency_schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /efficiency_schedules/1
  # DELETE /efficiency_schedules/1.xml
  def destroy
    @efficiency_schedule = EfficiencySchedule.find(params[:id])
    @efficiency_schedule.destroy

    respond_to do |format|
      format.html { redirect_to(efficiency_schedules_url) }
      format.xml  { head :ok }
    end
  end
end
