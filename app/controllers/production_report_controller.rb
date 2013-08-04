class ProductionReportController < ApplicationController
  before_filter :authenticate_user
  
  def index
    
  end

  def search_reject_report
    from = Date.parse(params[:from]) unless params[:from].blank?
    to = Date.parse(params[:to]) unless params[:to].blank?
    
    if params[:from].blank? or params[:to].blank?
      flash[:error] = "Please select the correct date"
      redirect_to :action => 'index'
    elsif from > to
      flash[:error] = "Please select the correct date"
      redirect_to :action => 'index'
    else
      redirect_to :action => 'reject_report', :from => from, :to => to
    end
  end
  
  def reject_report
    @transactions = current_user.generate_reject_report(params[:from], params[:to])
    if params[:category]
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="report.xls"'
      headers['Cache-Control'] = ''
      render :layout => false
    end
  end
  
  def group_by_machine
    transactions = current_user.generate_reject_report(params[:from], params[:to])
    transactions = transactions.sort_by {|t| t.machine.machine_number}
    @transactions = transactions.group_by {|c| c.machine }
    if params[:category]
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="report.xls"'
      headers['Cache-Control'] = ''
      render :layout => false
    end
  end
  
  def group_by_employee
    transactions = current_user.generate_reject_report(params[:from], params[:to])
    transactions = transactions.sort_by {|t| t.employee.employee_number}
    @transactions = transactions.group_by {|c| c.employee }
    if params[:category]
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="report.xls"'
      headers['Cache-Control'] = ''
      render :layout => false
    end
  end
  
  def group_by_reject_code
    transactions = current_user.generate_reject_report(params[:from], params[:to])
    transactions = transactions.sort_by {|t| t.reject_code.code}
    @transactions = transactions.group_by {|c| c.reject_code }
    if params[:category]
      headers['Content-Type'] = "application/vnd.ms-excel"
      headers['Content-Disposition'] = 'attachment; filename="report.xls"'
      headers['Cache-Control'] = ''
      render :layout => false
    end
  end
  
  

end
