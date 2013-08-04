class BoxLabelsController < ApplicationController
	before_filter :authenticate_admin
  def index
  	if params[:search] 
  	  params[:search][:boxed_date_time_lte] = params[:search][:boxed_date_time_lte].to_date.strftime("%Y-%m-%d 23:59:59") if params[:search][:boxed_date_time_lte] && !params[:search][:boxed_date_time_lte].blank?
  	  params[:search][:boxed_date_time_gte] = params[:search][:boxed_date_time_gte].to_date.strftime("%Y-%m-%d 00:00:00") if params[:search][:boxed_date_time_gte] && !params[:search][:boxed_date_time_gte].blank?
  	end
  	@search = BoxLabel.search(params[:search])
    @boxes  = @search.all(:order => "boxed_date_time DESC").paginate(:page => params[:page], :per_page => 20)
    @machines = Machine.all(:order => "machine_number")
    @employees = Employee.all(:order => "employee_number")
  end

  def show
  	@box_label = BoxLabel.find params[:id]
  end

  def print_barcode
  	@box = BoxLabel.find params[:id]
  	LabelEngine.new(@box).generate_label_content
  end

end
