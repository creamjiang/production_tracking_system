# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
   #include ExceptionNotifiable
   helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
   protect_from_forgery
  # Scrub sensitive parameters from your log
   filter_parameter_logging :password, :password_confirmation, :login
  

   helper_method :get_the_actual_date
   helper_method :current_user
   helper_method :current_user_id
   helper_method :current_user_name
   helper_method :is_admin?
   helper_method :is_user?
   helper_method :is_ict_admin?
   helper_method :is_application_admin?
   helper_method :is_report_viewer?
   helper_method :is_material_input?
   helper_method :is_supervisor?
   helper_method :is_technician?
   helper_method :is_operator?
   helper_method :is_reviewer?
   helper_method :is_prms_admin?
   
   protected
   
   def get_the_actual_date
    case Time.now.hour.to_i
      when 0..5
        return_date = Date.today - 1
      when 6..24
        return_date = Date.today
      end
      return_date.to_s
   end
   
   def get_the_yesterday
    case Time.now.hour.to_i
      when 0..5
        return_date = Date.today - 1
      when 6..24
        return_date = Date.today
      end
      (return_date - 1).to_s
   end
   
   def authenticate_admin
     unless is_admin?
       redirect_to :controller => 'login', :action => 'unauthorized_user'
     end
   end
   
   def authenticate_user
     unless is_user? or is_admin?
       redirect_to :controller => 'login', :action => 'unauthorized_user'
     end
   end
   
   def current_user
     #Employee.find(session[:user_id])
     session[:user_id] ? Employee.find(session[:user_id]) : session[:admin_id] ? Administrator.find(session[:admin_id]) : nil
   end

   def current_user_id
     session[:user_id] ? session[:user_id] : session[:admin_id] ? session[:admin_id] : 0
   end
   
   def current_user_name
     session[:user_id] ? Employee.find(session[:user_id]).name : session[:admin_id] ? Administrator.find(session[:admin_id]).name : ""
   end
 
   def is_admin?
     session[:admin_id]
   end
  
   def is_user?
     session[:user_id]
   end
 
   def is_ict_admin?
     session[:group_id] == Group::ICT_ADMIN
   end
   
   def is_application_admin?
     session[:group_id] == Group::APPLICATION_ADMIN
   end
 
   def is_report_viewer?
     session[:group_id] == Group::REPORT_VIEWER
   end
   
   def is_material_input?
     session[:group_id] == Group::MATERIAL_INPUT
   end

   def is_prms_admin?
     session[:group_id] == Group::PRMS_ADMIN
   end
 
   def is_supervisor?
     session[:department_id] == Department::SUPERVISOR
   end
   
   def is_technician?
     session[:department_id] == Department::TECHNICIAN
   end
   
   def is_operator?
     session[:department_id] == Department::OPERATOR
   end
 
   def is_reviewer?
     session[:department_id] == Department::REVIEWER
   end
   
end
