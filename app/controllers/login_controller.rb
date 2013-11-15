class LoginController < ApplicationController
  
  
  def index
  end

  def production_index
    if request.post?
      
      logged_user = Employee.try_to_login(params[:name], params[:password], params[:machine][:id])
      
      if logged_user.kind_of? Employee
        reset_session
        add_user_to_session(logged_user)
        #flash[:notice] = "Successfully login"
        if is_supervisor?
          redirect_to(:controller => 'main')
        else
          machine = Machine.find(params[:machine][:id].to_i)
          if machine and machine.is_bin_type_set?
            logged_user.add_login_record(params[:machine][:id].to_i)
            redirect_to(:controller => 'flow', :id => params[:machine][:id])
          else
            flash[:error] = "The bin type of attached products to this machine has not been set"
            redirect_to :action => :index
          end
        end
        
   
      else
        case logged_user
        when LoginRecord::INVALID_LOGIN
           flash[:error] = "Invalid login"
        when LoginRecord::INVALID_PASSWORD
           flash[:error] = "Invalid password"
        when LoginRecord::LOGIN_FREEZED
           flash[:error] = "Duplicate login on multiple machine is not allowed"
        when LoginRecord::INVALID_MACHINE
           flash[:error] = "Your ID is not yet register in this machine"
        end
            
        redirect_to :action => :index
      end
    
   else
    @machine = Machine.find_by_mac_address(params[:mac_address]) if params[:mac_address]
   end
 
  end
  
  def production_report_index
    if request.post?
      
      logged_user = Employee.supervisor_try_to_login(params[:name], params[:password])
   
      if logged_user
        reset_session
        add_user_to_session(logged_user)
        flash[:notice] = "Successfully login"
        redirect_to(:controller => 'main')
      else
        flash[:error] = "Invalid login"
      end
      
    end
    
  end
 
  def admin_index
    raise "Test error"
    if request.post?
      
      logged_user = Administrator.try_to_login(params[:name], params[:password])
   
      if logged_user
        reset_session
        add_user_to_session(logged_user)
        flash[:notice] = "Successfully login"
        redirect_to(:controller => 'main')
      else
     
        flash[:error] = "Invalid login"
      end
   end
  end
 
  def logout
  
    if is_admin?
      reset_session
      flash[:notice] = "Successfully logout"  
      redirect_to(:action => 'admin_index') 
    elsif is_operator?
      

      can_logout = true
      machine = Machine.find(params[:machine_id])
      if machine.is_barcode_mode?
        machine.attached_products.active.each do |attached_product|
          working_state = attached_product.working_states.first(:conditions => ["product_id = ? and machine_id = ? and routing_procedure_id = ?", attached_product.product_id, machine.id, attached_product.routing_procedure_id])
          unless working_state.full? || working_state.empty?
            can_logout = false
            break
          end
        end
      end

      if can_logout
        current_user.update_login_record(params[:machine_id].to_i)
        reset_session
        flash[:notice] = "Successfully logout"
        redirect_to(:action => 'index')
      else
        flash[:error] = "Failed to logout due to incomplete box"
        redirect_to(:controller => 'flow', :id => machine.id)
      end
    
    elsif is_supervisor?
      
      reset_session
      flash[:notice] = "Successfully logout"
      redirect_to('/supervisor')
      
    elsif is_technician?
      current_user.update_login_record(params[:machine_id].to_i)
      reset_session
      flash[:notice] = "Successfully logout"
      redirect_to(:action => 'index')
      
    elsif is_reviewer?
      current_user.update_login_record(params[:machine_id].to_i)
      reset_session
      flash[:notice] = "Successfully logout"
      redirect_to(:action => 'index')
      
    else
      reset_session
      flash[:notice] = "Successfully logout"
      redirect_to(:action => 'index')
    end
  end
 
 
  def unauthorized_user
    begin
      if is_supervisor?
        reset_session
        flash[:error] = "You have no right to access the area"
        redirect_to(:action => "production_report_index")
      elsif is_admin
        reset_session
        flash[:error] = "You have no right to access the area"
        redirect_to(:action => "admin_index")
      else
        reset_session
        flash[:error] = "You have no right to access the area"
        redirect_to(:action => "index")
      end
    rescue
      reset_session
        flash[:error] = "You have no right to access the area"
        redirect_to(:action => "admin_index")
    end
  end
  
 
 private

  def  add_user_to_session(logged_user)
    if logged_user.class.to_s == "Employee"
      session[:user_id] = logged_user.id
      session[:department_id] = logged_user.department_id
    elsif logged_user.class.to_s == "Administrator"
      session[:admin_id] = logged_user.id
      session[:group_id] = logged_user.group_id
    end
 end
  
  
end
