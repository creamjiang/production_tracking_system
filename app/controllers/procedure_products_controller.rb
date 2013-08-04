class ProcedureProductsController < ApplicationController
  
  before_filter :authenticate_user
  
  def index
    @procedure_products = ProcedureProduct.all
  end
  
  def show
    @procedure_product = ProcedureProduct.find(params[:id])
  end
  
  def new
    @procedure_product = ProcedureProduct.new
  end
  
  def create
    @procedure_product = ProcedureProduct.new(params[:procedure_product])
    if @procedure_product.save
      flash[:notice] = "Successfully created procedure product."
      redirect_to @procedure_product
    else
      render :action => 'new'
    end
  end
  
  def edit
    @procedure_product = ProcedureProduct.find(params[:id])
  end
  
  def update
    @procedure_product = ProcedureProduct.find(params[:id])
    if @procedure_product.update_attributes(params[:procedure_product])
      flash[:notice] = "Successfully updated procedure product."
      redirect_to @procedure_product
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @procedure_product = ProcedureProduct.find(params[:id])
    @procedure_product.destroy
    flash[:notice] = "Successfully destroyed procedure product."
    redirect_to procedure_products_url
  end
end
