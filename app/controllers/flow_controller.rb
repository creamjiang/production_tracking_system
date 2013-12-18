class FlowController < ApplicationController
  include FlushEngine
  #include BinEngine
  before_filter :authenticate_user
  before_filter :check_machine_status, :except => [:barcode, :index, :home, :confirm_down_reason, :machine_down, :machine_up,
                :down_reason_list, :top_5_reject_code, :top_5_down_code, :show_reject_codes, :show_reject_photo]
   
  def index
    #begin
      if params[:id]
        @machine = Machine.find(params[:id])
        session[:machine_id] = @machine.id
      else
        find_machine
      end
      find_shift

      @products = Product.generate_summary(@machine.attached_products.active, session[:shift_id], get_the_actual_date, @machine.id)
      @today = get_the_actual_date
      @yesterday = get_the_yesterday
      if @machine.is_data_entry?
       @shifts = @machine.shifts
       @dates = ((Date.today - 1.day)..Date.today).to_a.reverse
      end
      redirect_to(:action => 'home') if is_technician?
      
    #rescue
    #  flash[:error] = "No procedure assigned to this machine"
    #  redirect_to root_path
    #end
  end
 
  def home
    find_machine
    redirect_to :action => 'down_reason_list' if @machine.waiting_for_down_reason?
  end

  def down_reason_list
    find_machine
    procedure =  @machine.routing_procedures.first
    if procedure
      @reasons = @machine.routing_procedures.first.routing_process.machine_down_reasons.paginate(:page => params[:page], :per_page => 50, :order => "alias")
    else
      flash[:error] = "The machine dont have any routing procedure"
      redirect_to :controller => "login", :action => "logout", :machine_id => @machine.id
    end

  end

  def confirm_down_reason
    find_machine
    reason = MachineDownReason.find(params[:id])
    downtime = @machine.machine_downtimes.first(:conditions => "fixed = false")

    if downtime
      downtime.machine_down_reason_id = reason.id
      downtime.confirmed_reason_time = Time.now + 8.hours
      downtime.save!
      flash[:error] = "Machine down due to " + reason.description
    else
      flash[:error] = "Machine downtime not found"
    end
    redirect_to :action => "home"
  end

  def machine_down
    find_machine
    if @machine.down?
      flash[:error] = "Machine is already set to down status"
    else
      down_times = @machine.machine_downtimes.all(:conditions => "fixed = false")
      if down_times.size == 0
        downtime = MachineDowntime.new(:employee_id => current_user_id, :machine_id => @machine.id, :fixed => false, :shift_id => session[:shift_id], :down_date => get_the_actual_date)
        if downtime.save!
          @machine.update_attribute(:down, true)
          flash[:notice] = "Machine successfully set to down status"
        else
          flash[:error] = "Machine down time failed to save"
        end
      elsif down_times.size.to_i == 1
        flash[:error] = "The machine has unsettled downtime"
      elsif down_times.size.to_i > 1
        flash[:error] = "The machine has more than 1 unsettled downtime"
      else
        flash[:error] = "unknown reason"
      end
    end

   if is_technician?
      redirect_to :action => "home"
   elsif is_operator?
      redirect_to :action => "index"
   end

  end

  def machine_up
    find_machine
    downtimes = @machine.machine_downtimes.all(:conditions => "fixed = false")
    downtimes.each do |downtime|
      downtime.fixed = true
      downtime.fixed_time = Time.now + 8.hours
      downtime.save!
    end
    @machine.down = false
    @machine.save(false)
    if downtimes.size == 1
      flash[:notice] = "Machine Up"
    elsif downtimes.size > 1
      flash[:notice] = "All downtimes has been set to fix"
    end

    redirect_to :action => "home"
  end
  
  def submit_entry
    # if start_working(params[:attach_product_id])
      attach_product_id = params[:attach_product_id] if params[:attach_product_id]
      accept_quantity = params[:accept_quantity] if params[:accept_quantity]
      hold_quantity = params[:hold_quantity] if params[:hold_quantity]
      t = {}
      t[:date] = Date.parse(params[:t_date])
      t[:shift_id] = params[:shift_id]
      t[:hour] = params[:date][:hour]
      t[:minute] = params[:date][:minute]
      
      validate_entry_unit(attach_product_id, accept_quantity, ProcedureTransaction::GOOD, t) if attach_product_id
      validate_entry_unit(attach_product_id, hold_quantity, ProcedureTransaction::ONHOLD, t) if attach_product_id
      for num in (1..10)
        reject_process_id = params["reject"]["#{num.to_s}_process_id"]
        reject_code_id = params["reject"]["#{num.to_s}_reject_code_id_for_product_#{attach_product_id.to_s}"]
        reject_quantity = params["#{num.to_s}_reject_quantity"]
        reject_area = params["#{num.to_s}_reject_area"]
        
        validate_reject_unit(reject_area, attach_product_id, reject_process_id, reject_code_id, reject_quantity, t)
      end
      # @box = @working_space.box_label_creator(current_user_id, @product.id, @machine.id, accept_quantity, true)
      flash[:notice] = "Quantity successfully submited"
    # else
    #   flash[:error] = "The machine failed to start working"
    # end
    
    redirect_to :action => "index"
  end

  def print_label
    quantity = params[:label][:quantity]
    if quantity.blank?
      flash[:error] = "Quantity cannot be blank"
    else
      if quantity.strip =~ /\D/
        flash[:error] = "You cannot enter non digit character"
      else
        if start_working(params[:id])
          total = 0
          quantity.to_i.times do
            @box = @working_space.box_label_creator(current_user_id, @product.id, @machine.id, @working_space.maximum_load, true)
            total += @working_space.maximum_load
          end
          flash[:notice] = "#{quantity} labels have been sent to printer, total quantity of part is #{total}."
        else
          flash[:error] = "The machine failed to start working"
        end
      end
    end
    redirect_to :action => "index"
  end

  def barcode
    item = AttachedProduct.find(params[:id])
    if params[:category_id].to_i == 1
      product = item.product
      bin_type = item.bin_type
      @image = bin_type.generate_image(product)
      @name = product.part_number
    elsif params[:category_id].to_i == 2
      bin_type = item.bin_type
      @image = bin_type.generate_image(false)
      @name = bin_type.bin_barcode_text
    end
    render :layout => false
  end

  def accept
    if start_working(params[:id])
      input_good_unit
      @working_space.loaded_one_unit
      @working_space.label_items.create!(:procedure_transaction_id => @p_transaction.id)
      if @machine.is_barcode_mode?
        if @working_space.full?
          @box = @working_space.box_label_creator(current_user_id, @product.id, @machine.id)
          @working_space.reset
        end
      end
    end
    @product.today_transactions = @product.transaction_summaries.all(:conditions => ["machine_id = ? and processing_date = ?", @machine.id, get_the_actual_date], :order => "processing_date, shift_id")

    render :update do |page|
      page.replace_html('current_detail_'+@attached_product.id.to_s, :partial => 'attach_product', :locals => {:attach_product => @attached_product, :box_label => @box})
      page.replace_html('product_detail_'+@attached_product.id.to_s, "#{@attached_product.product.part_name} (#{@attached_product.product.part_number}) - #{@working_space ? (@working_space.loaded_unit.to_s + ' / ' + @working_space.maximum_load.to_s) : nil}")
    end
    
  end
  
  def hold
    if start_working(params[:id])
      input_hold_unit 
    end
    @product.today_transactions = @product.transaction_summaries.all(:conditions => ["machine_id = ? and processing_date = ?", @machine.id, get_the_actual_date], :order => "processing_date, shift_id")
    render :update do |page| 
      page.replace_html('current_detail_'+@attached_product.id.to_s, :partial => 'attach_product', :locals => {:attach_product => @attached_product})
      flash.clear
      page.replace_html('flash_div', :partial => "/layouts/production_flash_div")
    end
  end

  def show_reject_codes
    process = RoutingProcess.find(params[:id])
    @reject_codes = process.reject_codes.all(:conditions => "id > 0 and active = 1")
    select_id = params[:select_id]
    attach_product_id = params[:attach_product_id]
    render :update do |page|
        page.replace_html "reject_code_#{select_id.to_s}_for_product_#{attach_product_id.to_s}", :partial => 'reject_codes', :locals => {:i => params[:select_id].to_s, :reject_codes => @reject_codes, :attach_product_id => attach_product_id} #, :object => @person
    end
  end
  
  def select_reject_categories
    if params[:id]
      @attached_product = AttachedProduct.find(params[:id])
      @product = @attached_product.product
      @reject_area = params[:area_id]
      if @product
        check_selection
      else
        flash[:error] = "Cannot find product with the ID provided"
        redirect_to :action => 'index'
      end
    else
      flash[:error] = "Cannot find product"
      redirect_to :action => "index"
    end
  end

  def select_reject_area
    if params[:id]
      @attached_product = AttachedProduct.find(params[:id])
      @product = @attached_product.product

      unless @product
        flash[:error] = "Cannot find product with the ID provided"
        redirect_to :action => 'index'
      end
    else
      flash[:error] = "Cannot find product"
      redirect_to :action => "index"
    end
  end
  
  def confirm_reject_code
    @attached_product = AttachedProduct.find(params[:attached_id])
    @product = @attached_product.product
    @process = RoutingProcess.find(params[:id]) #@attached_product.routing.routing_processes.
    @reasons = @process.reject_codes
    @reject_area = params[:area_id]
  end
  
  def reject
    begin
      reject_item = RejectCode.find(params[:reject_code_id])
      @reject_area = params[:area_id]
      status = start_working(params[:id])
      input_reject_unit(reject_item) if status
      #flash[:notice] = "1 Bad Unit Rejected for " + @working_space.product.part_name
      redirect_to :action => 'index'
    #rescue
    #  flash[:error] = "You need to select a reject reason to submit "
    #  redirect_to :action => 'index'
    end
  end
  
  def show_reject_photo
    reject_code = RejectCode.find(params[:id])
    @photos = reject_code.photos
    render :update do |page| 
      page.replace_html 'display_area', :partial => 'show_photos' #, :object => @person
    end
  end

  def checkout
    if @machine.is_barcode_mode?
      if start_working(params[:id])
        unless @working_space.full? || @working_space.empty?
          @working_space.box_label_creator(current_user_id, @product.id, @machine.id)
          @working_space.reset
          render :update do |page|
            page.replace_html('product_detail_'+@attached_product.id.to_s, "#{@attached_product.product.part_name} (#{@attached_product.product.part_number}) - #{@working_space ? (@working_space.loaded_unit.to_s + ' / ' + @working_space.maximum_load.to_s) : nil}")
          end
        end
      end
    end
  end
  
  def top_5_down_code
    find_machine
    @shifts = @machine.shifts
    query_date = get_the_actual_date
    @today = query_date
    @yesterday = get_the_yesterday

    if params[:id]
      shift_id = params[:id].to_i
    else
      shift_id = session[:shift_id]
    end

    @shift_name = Shift.find(shift_id).name rescue "Unknown"
    @yesterday_items = MachineDowntime.find_by_sql("SELECT count(*) as quantity, machine_down_reason_id  FROM machine_downtimes where down_date = '#{(Date.parse(query_date) - 1)}' and shift_id = #{shift_id} and machine_id = #{@machine.id} GROUP BY machine_down_reason_id ORDER BY quantity DESC, machine_down_reason_id")
    @items = MachineDowntime.find_by_sql("SELECT count(*) as quantity, machine_down_reason_id  FROM machine_downtimes where down_date = '#{query_date}' and shift_id = #{shift_id} and machine_id = #{@machine.id} GROUP BY machine_down_reason_id ORDER BY quantity DESC, machine_down_reason_id")
  end
  
  def top_5_reject_code
     find_machine
     @shifts = @machine.shifts
     @today = get_the_actual_date
     #@yesterday = get_the_yesterday
     
     if params[:id]
       shift_id = params[:id].to_i  
     else
       shift_id = session[:shift_id]  
     end
     
     @shift_name = Shift.find(shift_id).name rescue "Unknown"
     
     #@yesterday_items = ProcedureTransaction.find_by_sql("SELECT count(*) as quantity, reject_code_id  FROM procedure_transactions where status = #{ProcedureTransaction::REJECT} and transaction_date = '#{(Date.parse(query_date) - 1)}' and shift_id = #{shift_id} and machine_id = #{@machine.id} GROUP BY reject_code_id ORDER BY quantity DESC, reject_code_id")
     @items = ProcedureTransaction.generate_report(@today, shift_id, @machine.id)
     #find_by_sql("SELECT count(*) as quantity, reject_code_id FROM procedure_transactions where reject_code_id > 0 and transaction_date = '#{query_date}' and shift_id = #{shift_id} and machine_id = #{@machine.id} GROUP BY reject_code_id ORDER BY quantity DESC, reject_code_id")
  end
  
  private
  
  def find_shift
    shift = @machine.current_shift
    if shift
      session[:shift_id] = shift.id
    else
      session[:shift_id] = 0
    end
  end
  
  def find_machine
    @machine ||= Machine.find(session[:machine_id])
  end

  def start_working(attach_product_id)
    find_shift
    @attached_product = AttachedProduct.find(attach_product_id)
    @product = @attached_product.product

    if @product
      @working_space ||= @attached_product.working_states.first(:conditions => ["product_id = ? and machine_id = ? and routing_procedure_id = ?", @product.id, @machine.id, @attached_product.routing_procedure_id])
      unless @working_space
        #bin = Bin.check_available_bin(@product)
        @working_space = @attached_product.working_states.create!(:maximum_load => @attached_product.bin_type.maximum_load, :bin_type_id => @attached_product.bin_type_id, :machine_id => @machine.id, :product_id => @product.id, :routing_procedure_id => @attached_product.routing_procedure_id)
      end
      @bin_type ||= @working_space.bin_type
      @working_space.update_attributes(:maximum_load => @bin_type.maximum_load) if @working_space.maximum_load != @bin_type.maximum_load
      #@container ||= @bin.bin_type.containers.first(:conditions => ["product_id = ?", @product.id])
      #todo : create workspace
      #session[:working_id] = @working_space.id
      true
    else
      false
    end
  end

  def check_selection
    procedure = @attached_product.routing_procedure
    @processes = @attached_product.routing.collect_processes(procedure)
    @reasons = procedure.routing_process.reject_codes.all(:conditions => "id > 0")
    #redirect_to :action => "confirm_reject_code", :id => @processes[0].id if @processes.size == 1
  end
  
  def validate_reject_unit(reject_category, att_product_id, process_id, reject_code_id, quantity, item)
    unless att_product_id.blank? || process_id.blank? || reject_code_id.blank? || quantity.blank? ||  quantity.index(/[abcdefghijklmnopqrstuvwxyz]/) || quantity.to_i <= 0
      reject_code = RejectCode.find(reject_code_id)
      @reject_area = reject_category
      status = start_working(att_product_id)
      input_reject_unit_for_data_entry(reject_code, item, quantity.to_i) if status 
    end
  end
  
  def validate_entry_unit(att_product_id, quantity, unit_status, item)
    case unit_status.to_i
      when ProcedureTransaction::GOOD
        unless att_product_id.blank? || quantity.blank? ||  quantity.index(/[abcdefghijklmnopqrstuvwxyz]/) || quantity.to_i <= 0
          status = start_working(att_product_id)
          input_good_unit_for_data_entry(item, quantity.to_i) if status 
        end
      when ProcedureTransaction::ONHOLD
        unless att_product_id.blank? || quantity.blank? ||  quantity.index(/[abcdefghijklmnopqrstuvwxyz]/) || quantity.to_i <= 0
          status = start_working(att_product_id)
          input_hold_unit_for_data_entry(item, quantity.to_i) if status
        end
    end
  end

  def input_good_unit_for_data_entry(items, quantity)
    ActiveRecord::Base.transaction do
      @p_transaction = @product.procedure_transactions.new(:quantity => quantity, :reject_code_id => DailyTransaction::GOOD, :employee_id => current_user_id, :routing_procedure_id => @attached_product.routing_procedure_id, :routing_id => @attached_product.routing_id, :routing_process_id => @attached_product.routing_process_id, :machine_id => @machine.id, :bin_type_id => @bin_type.id, :status => ProcedureTransaction::GOOD, :transaction_date => items[:date], :shift_id => items[:shift_id])
      @p_transaction.part_cost = @product.part_cost
      flush_operation(items[:date].to_s, quantity) #if Setting.first.enable_flush?
      @p_transaction.created_at = Time.parse(items[:date].to_s + " " + items[:hour].to_s + ":" + items[:minute].to_s + ":00") + 8.hours
      @p_transaction.save(false)
      @machine.find_or_generate_transaction_summary(quantity, @product.id, current_user_id, @attached_product.routing_procedure_id, @attached_product.routing_id, @attached_product.routing_process_id, items[:date], items[:shift_id], ProcedureTransaction::GOOD)
      DailyTransaction.generate_summary("00", @product.id, @attached_product.routing_id, @attached_product.routing_process_id, items[:date], DailyTransaction::GOOD, quantity)
    end
    
    #@bin.check_bin_status(@working_space, @container)
  end
  
  def input_good_unit
    ActiveRecord::Base.transaction do
      @p_transaction = @product.procedure_transactions.create!(:part_cost => @product.part_cost, :quantity => 1, :reject_code_id => DailyTransaction::GOOD, :employee_id => current_user_id, :routing_procedure_id => @attached_product.routing_procedure_id, :routing_id => @attached_product.routing_id, :routing_process_id => @attached_product.routing_process_id, :machine_id => @machine.id, :bin_type_id => @bin_type.id, :status => ProcedureTransaction::GOOD, :transaction_date => get_the_actual_date, :shift_id => session[:shift_id])
      flush_operation(get_the_actual_date, 1)
      @machine.find_or_generate_transaction_summary(1, @product.id, current_user_id, @attached_product.routing_procedure_id, @attached_product.routing_id, @attached_product.routing_process_id, get_the_actual_date, session[:shift_id], ProcedureTransaction::GOOD)
      DailyTransaction.generate_summary("00", @product.id, @attached_product.routing_id, @attached_product.routing_process_id, get_the_actual_date, DailyTransaction::GOOD, 1)
       #if Setting.first.enable_flush?
    end
  end
  
  def input_hold_unit_for_data_entry(items, quantity)
    ActiveRecord::Base.transaction do
      trans = @product.procedure_transactions.new(:quantity => quantity, :reject_code_id => DailyTransaction::ONHOLD, :employee_id => current_user_id, :routing_procedure_id => @attached_product.routing_procedure_id, :routing_id => @attached_product.routing_id, :routing_process_id => @attached_product.routing_process_id, :machine_id => @machine.id, :bin_type_id => @bin_type.id, :status => ProcedureTransaction::ONHOLD, :transaction_date => items[:date], :shift_id => items[:shift_id])
      trans.part_cost = @product.part_cost
      trans.created_at = Time.parse(items[:date].to_s + " " + items[:hour].to_s + ":" + items[:minute].to_s + ":00") + 8.hours
      trans.save(false)
      trans.generate_cold_store(quantity, items[:date], ProcedureTransaction::ONHOLD, @product.id)
      @machine.find_or_generate_transaction_summary(quantity, @product.id, current_user_id, @attached_product.routing_procedure_id, @attached_product.routing_id, @attached_product.routing_process_id, items[:date], items[:shift_id], ProcedureTransaction::ONHOLD)
      DailyTransaction.generate_summary("00", @product.id, @attached_product.routing_id, @attached_product.routing_process_id, items[:date], DailyTransaction::ONHOLD, quantity)
    end
      #@bin.check_bin_status(@working_space, @container)
  end
  
  def input_hold_unit
    ActiveRecord::Base.transaction do
      trans = @product.procedure_transactions.create!(:part_cost => @product.part_cost, :reject_code_id => DailyTransaction::ONHOLD, :employee_id => current_user_id, :routing_procedure_id => @attached_product.routing_procedure_id, :routing_id => @attached_product.routing_id, :routing_process_id => @attached_product.routing_process_id, :machine_id => @machine.id, :bin_type_id => @bin_type.id, :status => ProcedureTransaction::ONHOLD, :transaction_date => get_the_actual_date, :shift_id => session[:shift_id])
      trans.generate_cold_store(1, get_the_actual_date, ProcedureTransaction::ONHOLD, @product.id)
      @machine.find_or_generate_transaction_summary(1, @product.id, current_user_id, @attached_product.routing_procedure_id, @attached_product.routing_id, @attached_product.routing_process_id, get_the_actual_date, session[:shift_id], ProcedureTransaction::ONHOLD)
      DailyTransaction.generate_summary("00", @product.id, @attached_product.routing_id, @attached_product.routing_process_id, get_the_actual_date, DailyTransaction::ONHOLD, 1)
    end
      #@bin.check_bin_status(@working_space, @container)
  end
  
  def input_reject_unit_for_data_entry(reject_code, items, quantity)
    @routine_product = RoutineProduct.first(:conditions => ["routing_procedure_id = ? and product_id = ?", @attached_product.routing_procedure_id, @attached_product.product_id])
    ActiveRecord::Base.transaction do
      new_item = @product.procedure_transactions.new(:reject_area => @reject_area, :quantity => quantity, :reject_code_id => reject_code.id, :employee_id => current_user_id, :routing_procedure_id => @attached_product.routing_procedure_id, :routing_id => @attached_product.routing_id, :routing_process_id => @attached_product.routing_process_id, :machine_id => @machine.id, :bin_type_id => @bin_type.id, :status => ProcedureTransaction::REJECT, :transaction_date => items[:date], :shift_id => items[:shift_id])
      new_item.part_cost = @product.part_cost
      new_item.created_at = Time.parse(items[:date].to_s + " " + items[:hour].to_s + ":" + items[:minute].to_s + ":00") + 8.hours
      flush_operation(items[:date].to_s, quantity) if @routine_product.reject_include? if @routine_product
      new_item.save(false)
      
      @machine.find_or_generate_transaction_summary(quantity, @product.id, current_user_id, @attached_product.routing_procedure_id, @attached_product.routing_id, @attached_product.routing_process_id, items[:date], items[:shift_id], ProcedureTransaction::REJECT)
      DailyTransaction.generate_summary(@reject_area, @product.id, @attached_product.routing_id, @attached_product.routing_process_id, items[:date], reject_code.id, quantity)
    end
      #@bin.check_bin_status(@working_space, @container)
  end
  
  def input_reject_unit(reject_code)
    @routine_product = RoutineProduct.first(:conditions => ["routing_procedure_id = ? and product_id = ?", @attached_product.routing_procedure_id, @attached_product.product_id])
    ActiveRecord::Base.transaction do
      @product.procedure_transactions.create!(:part_cost => @product.part_cost, :reject_area => @reject_area, :reject_code_id => reject_code.id, :employee_id => current_user_id, :routing_procedure_id => @attached_product.routing_procedure_id, :routing_id => @attached_product.routing_id, :routing_process_id => @attached_product.routing_process_id, :machine_id => @machine.id, :bin_type_id => @bin_type.id, :status => ProcedureTransaction::REJECT, :transaction_date => get_the_actual_date, :shift_id => session[:shift_id])
      flush_operation(get_the_actual_date, 1) if @routine_product.reject_include? if @routine_product
      @machine.find_or_generate_transaction_summary(1, @product.id, current_user_id, @attached_product.routing_procedure_id, @attached_product.routing_id, @attached_product.routing_process_id, get_the_actual_date, session[:shift_id], ProcedureTransaction::REJECT)
      DailyTransaction.generate_summary(@reject_area, @product.id, @attached_product.routing_id, @attached_product.routing_process_id, get_the_actual_date, reject_code.id, 1)
    end
      #@bin.check_bin_status(@working_space, @container)
  end

  def check_machine_status
   find_machine
   if @machine.down
     flash[:error] = "Machine is down, please activate it first"
     redirect_to :action => "index"
   end
  end
  
end
