class TransactionSummariesController < ApplicationController
  before_filter :authenticate_admin
  
  def index
    @transaction_summaries = TransactionSummary.all
  end
  
  def show
    @transaction_summary = TransactionSummary.find(params[:id])
  end
  
  def new
    @transaction_summary = TransactionSummary.new
  end
  
  def create
    @transaction_summary = TransactionSummary.new(params[:transaction_summary])
    if @transaction_summary.save
      flash[:notice] = "Successfully created transaction summary."
      redirect_to @transaction_summary
    else
      render :action => 'new'
    end
  end
  
  def edit
    @transaction_summary = TransactionSummary.find(params[:id])
  end
  
  def update
    @transaction_summary = TransactionSummary.find(params[:id])
    if @transaction_summary.update_attributes(params[:transaction_summary])
      flash[:notice] = "Successfully updated transaction summary."
      redirect_to @transaction_summary
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @transaction_summary = TransactionSummary.find(params[:id])
    @transaction_summary.destroy
    flash[:notice] = "Successfully destroyed transaction summary."
    redirect_to transaction_summaries_url
  end
end
