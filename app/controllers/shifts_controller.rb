class ShiftsController < ApplicationController
  before_filter :authenticate_user
  
  def index
    @shifts = Shift.all.paginate(:page => params[:page], :per_page => 50)
  end
  
  def show
    @shift = Shift.find(params[:id])
  end
  
  def new
    @shift = Shift.new
  end
  
  def create
    @shift = Shift.new(params[:shift])
    if @shift.save
      flash[:notice] = "Successfully created shift."
      redirect_to @shift
    else
      render :action => 'new'
    end
  end
  
  def edit
    @shift = Shift.find(params[:id])
  end
  
  def update
    @shift = Shift.find(params[:id])
    if @shift.update_attributes(params[:shift])
      flash[:notice] = "Successfully updated shift."
      redirect_to @shift
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @shift = Shift.find(params[:id])
    if @shift.verify_for_destroy
      flash[:notice] = "Successfully destroyed shift."
    else
      flash[:error] = "Cannot destroy the shift because it's in used."
    end

    redirect_to shifts_url
  end
end
