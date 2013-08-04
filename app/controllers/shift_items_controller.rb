class ShiftItemsController < ApplicationController
  before_filter :authenticate_user
  
  def index
    @shift_items = ShiftItem.all
  end
  
  def show
    @shift_item = ShiftItem.find(params[:id])
  end
  
  def new
    @shift_item = ShiftItem.new
  end
  
  def create
    @shift_item = ShiftItem.new(params[:shift_item])
    if @shift_item.save
      flash[:notice] = "Successfully created shift item."
      redirect_to @shift_item
    else
      render :action => 'new'
    end
  end
  
  def edit
    @shift_item = ShiftItem.find(params[:id])
  end
  
  def update
    @shift_item = ShiftItem.find(params[:id])
    if @shift_item.update_attributes(params[:shift_item])
      flash[:notice] = "Successfully updated shift item."
      redirect_to @shift_item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @shift_item = ShiftItem.find(params[:id])
    @shift_item.destroy
    flash[:notice] = "Successfully destroyed shift item."
    redirect_to shift_items_url
  end
end
