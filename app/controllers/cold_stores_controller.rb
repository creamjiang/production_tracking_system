class ColdStoresController < ApplicationController
  include FlushEngine
  before_filter :authenticate_user
  
  def index
    
    if params[:on_hold_date]
      if params[:on_hold_date].blank? 
        session[:date] = nil
      else
        session[:date] = Date.parse(params[:on_hold_date]).strftime("%Y-%m-%d")
      end
    end
    
    @search = ColdStore.search(params[:search])
    
    if is_admin?
      
      if is_application_admin?
        redirect_to :action => 'new'
      else
        @products = Product.all(:order => "part_number")
        if params[:search]
          if session[:date]
            @cold_stores = @search.all(:include => [:product, {:procedure_transaction => [:employee, :machine]}], :conditions => ["on_hold_date = ? and status = ?", session[:date], ProcedureTransaction::ONHOLD]).paginate(:page => params[:page], :per_page => 50)
          else
            @cold_stores = @search.all(:include => [:product, {:procedure_transaction => [:employee, :machine]}], :conditions => ["status = ?", ProcedureTransaction::ONHOLD]).paginate(:page => params[:page], :per_page => 50)
          end
          @quantity = @cold_stores.inject(0) {|sum, c| sum+= c.quantity}
        else
          @cold_stores = []
          @quantity = 0
        end
        
      end
      
    elsif is_supervisor?
      redirect_to :action => 'new'
    end
  end
  
  def show
    @cold_store = ColdStore.find(params[:id])
  end
  
  def new
    @cold_store = ColdStore.new
    
#    if is_ict_admin?
#      @attach_products = RoutingProcedure.all(:order => "routing_id, routing_process_id")
#    elsif is_application_admin? or is_spervisor?
      @attach_products = current_user.routing_procedures_on_hold_products
#    end
  end
  
#  def show_procedure_product
#    begin
#      procedure = RoutingProcedure.find(params[:id]) rescue nil
#      if procedure
#         @products = procedure.get_all_machines_products
#      else
#        @products = []
#      end
#
#    rescue
#      @products = []
#    end
#    render :update do |page|
#      if params[:area].to_i == 1
#        page.replace_html 'accept_product_selection', :partial => 'show_accept_products' #, :object => @person
#      else
#        page.replace_html 'reject_product_selection', :partial => 'show_reject_products' #, :object => @person
#      end
#
#    end
#  end
  
  def show_process_reject_code
    begin
      routing_process = RoutingProcess.find(params[:id]) rescue nil
      if routing_process
        @reasons = routing_process.machine_down_reasons(:order => "alias")
      else
        @reasons = []
      end
  
    rescue
      @reason = []
    end
    render :update do |page| 
      page.replace_html 'reject_code_selection', :partial => 'show_reject_codes' #, :object => @person
    end
  end
  
  def show_reject_photo
    reject_code = RejectCode.find(params[:id])
    @photos = reject_code.photos
    render :update do |page| 
      page.replace_html 'display_area', :partial => 'show_photos' #, :object => @person
    end
  end
  
  def show_accept_product_photo
    @attached_product = AttachedProduct.find(params[:id])
    @good_product = @attached_product.product
    @quantity = ColdStore.product_quantity(@good_product.id)
    render :update do |page| 
      page.replace_html 'good_area_product', :partial => 'good_area_product', :locals => {:product => @good_product} 
    end
  end
  
  def show_reject_product_photo
    @attached_product = AttachedProduct.find(params[:id])
    @reject_product = @attached_product.product
    @quantity = ColdStore.product_quantity(@reject_product.id)
    render :update do |page| 
      page.replace_html 'reject_area_product', :partial => 'reject_area_product', :locals => {:product => @reject_product}  #, :object => @person
    end
  end
  
  def add_good_unit
    if params[:transaction][:attached_product_id].blank?
      flash[:error] = "Please choose a Product"
    else
      if params[:good_quantity].blank? ||  params[:good_quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) || params[:good_quantity].to_i <= 0
        flash[:error] = "Please enter a quantity to process"
      else
        if params[:convert_date].blank?
          flash[:error] = "Please choose a valid date"
        else
          begin
            convert_date = Date.parse(params[:convert_date])
            quantity = params[:good_quantity].to_i rescue 0
            @attached_product = AttachedProduct.find(params[:transaction][:attached_product_id].to_i)
            @product = @attached_product.product
            if quantity > 0
              flush_operation(convert_date, quantity)
              flash[:notice] = ColdStore.convert_to_good_unit(@attached_product, quantity, convert_date, current_user_id)
              
            else
              flash[:error] = "You have input zero quantity"
            end
          #rescue Exception => exc
          #  flash[:error] = exc.message + "<br />" + "Please contact your administrator about this error"
          end
         end
       end
    end
    redirect_to new_cold_store_path
  end
  
  def add_reject_unit
      if params[:transaction][:attached_product_id].blank?
        flash[:error] = "Please choose a Product"
      else
        if params[:reject_quantity].blank? or params[:reject_quantity].index(/[abcdefghijklmnopqrstuvwxyz]/) or params[:reject_quantity].to_i <= 0
          flash[:error] = "Please enter a quantity to process"
        else
          if params[:convert_date].blank?
            flash[:error] = "Please choose a valid date"
          else
            begin
              convert_date = Date.parse(params[:convert_date])
              quantity = params[:reject_quantity].to_i rescue quantity = 0
              @attached_product = AttachedProduct.find(params[:transaction][:attached_product_id].to_i)
              @product = @attached_product.product
              @routine_product = RoutineProduct.first(:conditions => ["routing_procedure_id = ? and product_id = ?", @attached_product.routing_procedure_id, @attached_product.product_id])
              if quantity > 0
                flush_operation(convert_date, quantity) if @routine_product.reject_include? if @routine_product
                flash[:notice] = ColdStore.convert_to_reject_unit(@attached_product, quantity, convert_date, current_user_id)
              else
                flash[:error] = "You have input zero quantity"
              end
            #rescue Exception => exc
            #  flash[:error] = exc.message + "<br />" + "Please contact your administrator about this error"
            end
          end
        end
      end
    redirect_to new_cold_store_path
  end
  
  

end
