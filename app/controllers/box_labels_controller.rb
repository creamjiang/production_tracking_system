class BoxLabelsController < ApplicationController
	before_filter :authenticate_admin
  def index
    session[:label_index] = request.fullpath
  	# if params[:search] 
  	#   params[:search][:boxed_date_time_less_than_or_equal_to] = params[:search][:boxed_date_time_less_than_or_equal_to].to_date.strftime("%Y-%m-%d 23:59:59") if params[:search][:boxed_date_time_less_than_or_equal_to] && !params[:search][:boxed_date_time_less_than_or_equal_to].blank?
  	#   params[:search][:boxed_date_time_greater_than_or_equal_to] = params[:search][:boxed_date_time_greater_than_or_equal_to].to_date.strftime("%Y-%m-%d 00:00:00") if params[:search][:boxed_date_time_greater_than_or_equal_to] && !params[:search][:boxed_date_time_greater_than_or_equal_to].blank?
  	# end
    if params[:search]
      if params[:search][:product_part_number_equals].blank?
    	  @search = BoxLabel.search(params[:search])
      else
        part_number = params[:search].delete(:product_part_number_equals)
        @search = BoxLabel.search(params[:search])
      end
    else
      @search = BoxLabel.search(params[:search])
    end

    
    if is_ict_admin?
      @machines = Machine.all(:order => "machine_number")
      @employees = Employee.all(:order => "employee_number")
      if part_number
        @boxes  = @search.all(:joins => :product, :conditions => {"products.part_number" => part_number}, :order => "boxed_date_time DESC").paginate(:page => params[:page], :per_page => 20)
      else
        @boxes  = @search.all(:order => "boxed_date_time DESC").paginate(:page => params[:page], :per_page => 20)
      end
    else
      @products = current_user.products
      @machines = current_user.belongs_machines(Machine.all)
      @employees = current_user.belongs_operators
      @boxes  = @search.all(:joins => :product, :conditions => ["products.id IN(?)", @products.map(&:id)], :order => "boxed_date_time DESC").paginate(:page => params[:page], :per_page => 20)
    end
  end

  def show
  	@box_label = BoxLabel.find params[:id]
  end

  def print_barcode
  	@box = BoxLabel.find params[:id]
  	LabelEngine.new(@box).generate_label_content
    flash[:notice] = "Label has been sent to printing."
    redirect_to :action => "index"
  end

end
