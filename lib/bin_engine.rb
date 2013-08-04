module BinEngine

  def self.included m
    return unless m < ActionController::Base
  end

  def print_query
    attach_product = AttachedProduct.find(params[:id].to_i)
    @bin_type = attach_product.bin_type
    count = print_barcode(params[:category_id].to_i)
    if count == 9
      flash[:notice] = "Printing Completed"
    elsif count == 999
      flash[:error] = "Web service Error !"
    else
      flash[:error] = "Printer Error !"
    end
    
    redirect_to :action => "index"
  end

  def print_barcode(category_id)
    require 'rest_client'
    if category_id == 1 #print bin barcode
      content = @bin_type.bin_barcode_text
    elsif category_id == 2 #print product barcode
      content = @bin_type.product_barcode_text
    end

    retry_count = 0
    begin
      while retry_count < 4
        response = RestClient.get "http://"+request.remote_ip.to_s+":3000/printers/query?#{content}"
        case response.code
        when 200
          RestClient.get "http://"+request.remote_ip.to_s+":3000/printers/print_barcode?#{content}"
          retry_count = 9
        else
          retry_count += 1
        end
      end
    rescue
      retry_count = 999
    end
    retry_count
  end


  #  def list_bin_types
#    @bin_types = BinType.all(:order => "name")
#  end
#
#  def list_full_bin
#    bin_type = BinType.find(params[:id])
#    @bins = Bin.full(bin_type)
#  end
#
#  def clear_bin
#    render :layout => false
#  end
#
#  def clearing_bin
#    bin = Bin.find_by_bin_number(params[:bin_number])
#    if bin
#      if bin.bin_status_id == BinStatus::FULL
#        bin.clear_bin(current_user_id)
#        flash[:notice] = "The bin has been cleared"
#        redirect_to_clear_bin_method
#
#      else
#        flash[:error] = "The bin is not full or not being used"
#
#      end
#    else
#      flash[:error] = "Cannot find the bin"
#      redirect_to_clear_bin_method
#
#    end
#
#  end
#
#  def register_bin
#
#    find_routing_procedure
#    find_product
#    render :layout => false
#  end
#
#  def list_bin_types_for_register
#    find_product
#    @bin_types = Container.container(@product.id)
#  end
#
#  def select_bin
#    find_product
#    bin_type = BinType.find(params[:id])
#    @bins = BinType.collect_bins(bin_type)
#  end
#
#  def search_bin
#
#    find_routing_procedure
#    find_product
#    bin = Bin.find_by_bin_number(params[:bin_number])
#    if bin
#
#      if bin.bin_type.products.include?(@product)
#        if bin.bin_status_id == BinStatus::AVAILABLE
#
#          working_space = @routing_procedure.working_states.create(:machine_id => @machine.id, :employee_id => current_user_id, :bin_id => bin.id, :product_id => @product.id)
#          bin.update_attribute(:bin_status_id, BinStatus::INITIALIZE)
#          session[:working_id] = working_space.id
#          redirect_to :action => "working"
#        else
#          flash[:error] = "The bin is yet not available to use"
#
#          redirect_to_register_bin_method
#        end
#      else
#        flash[:error] = "The bin cannot load the product, please contact Administrator"
#
#        redirect_to_register_bin_method
#      end
#    else
#      flash[:error] = "Cannot find the Bin, please contact Administrator"
#
#      redirect_to_register_bin_method
#    end
#
#  end

#  def working
#    find_container
#
#    if @container
#
#      if @working_space.total_unit == @container.maximum_load
#        @working_space.destroy
#        flash[:notice] = "The bin is full"
#        redirect_to :action => 'index'
#      end
#    else
#      flash[:error] = "The bin is not yet configured a container"
#      redirect_to :action => "index"
#    end
#
#    @product.generate_yesterday_summary(session[:shift_id], get_the_actual_date, @machine.id)
#
#  end

  #  def rescan_bin
#    find_bin
#    if @working_space.total_unit == 0
#      @working_space.destroy
#      @bin.update_attribute(:bin_status_id, BinStatus::AVAILABLE)
#      flash[:error] = "Bin " + @bin.bin_number + " has been cancel"
#      #redirect_to :action => "register_bin"
#      redirect_to_register_bin_method
#    else
#      flash[:error] = "Bin " + @bin.bin_number + " cannot be cancel"
#      redirect_to :action => "working"
#    end
#
#  end

#  private

#  def redirect_to_register_bin_method
#    setting = Setting.first
#    if setting.register_bin_with_scanner
#      redirect_to(:action => 'register_bin')
#    else
#      redirect_to(:action => 'list_bin_types_for_register')
#    end
#  end
#
#  def redirect_to_clear_bin_method
#    setting = Setting.first
#    if setting.register_bin_with_scanner
#      redirect_to(:action => 'clear_bin')
#    else
#      redirect_to(:action => 'list_bin_types')
#    end
#  end

  

end
