class BoxLabelsController < ApplicationController
	before_filter :authenticate_admin
  def index
  	# if params[:search] 
  	#   params[:search][:boxed_date_time_less_than_or_equal_to] = params[:search][:boxed_date_time_less_than_or_equal_to].to_date.strftime("%Y-%m-%d 23:59:59") if params[:search][:boxed_date_time_less_than_or_equal_to] && !params[:search][:boxed_date_time_less_than_or_equal_to].blank?
  	#   params[:search][:boxed_date_time_greater_than_or_equal_to] = params[:search][:boxed_date_time_greater_than_or_equal_to].to_date.strftime("%Y-%m-%d 00:00:00") if params[:search][:boxed_date_time_greater_than_or_equal_to] && !params[:search][:boxed_date_time_greater_than_or_equal_to].blank?
  	# end
  	@search = BoxLabel.search(params[:search])
    if is_ict_admin?
      @boxes  = @search.all(:order => "boxed_date_time DESC").paginate(:page => params[:page], :per_page => 20)
    else
      @boxes  = current_user.belongs_products(@search.all).paginate(:page => params[:page], :per_page => 20)
    end
    
    if is_ict_admin?
      @machines = Machine.all(:order => "machine_number")
      @employees = Employee.all(:order => "employee_number")
    else
      @products = current_user.products
      @machines = current_user.belongs_machines(Machine.all)
      @employees = current_user.belongs_operators
    end
  end

  def show
  	@box_label = BoxLabel.find params[:id]
  end

  def print_barcode
  	@box = BoxLabel.find params[:id]
  	LabelEngine.new(@box).generate_label_content
  end

end
