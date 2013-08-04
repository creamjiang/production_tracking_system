module FlushEngine
  
  def self.included m
    return unless m < ActionController::Base
  end

  def flush_operation(request_date, request_quantity)
    @account = @product.account_statements.first(:conditions => ["routing_procedure_id = ? and account_month = ? and account_year = ?", @attached_product.routing_procedure_id, request_date.to_date.month, request_date.to_date.year], :lock => true)
    if @account
      @account.quantity_in += request_quantity
      @account.save!
      
    else
      @account = @product.account_statements.new(:quantity_in => request_quantity, :routing_procedure_id => @attached_product.routing_procedure_id, :account_month => request_date.to_date.month, :account_year => request_date.to_date.year)
      found = @product.account_statements.last(:conditions => ["routing_procedure_id = ? and account_month < ? and account_year <= ?", @attached_product.routing_procedure_id, request_date.to_date.month, request_date.to_date.year], :order => "account_year, account_month")
      @account.opening_balance = found.closing_balance if found
      @account.save!
    end
    update_later_statement
    update_product_balance(request_quantity)
  end

  private

  def update_later_statement
    found = @product.account_statements.all(:conditions => ["routing_procedure_id = ? and account_year >= ? and account_month > ?", @attached_product.routing_procedure_id, @account.account_year, @account.account_month], :order => "account_year, account_month")
    @balance = @account.closing_balance
    found.each do |f|
      f.opening_balance = @balance
      f.save!
      @balance = f.closing_balance
    end
  end

  def update_product_balance(qty)
    found = ProductBalance.first(:conditions => ["routing_procedure_id = ? and product_id = ?", @attached_product.routing_procedure_id, @product.id])
    unless found
      found = ProductBalance.new(:product_id => @product.id, :routing_procedure_id => @attached_product.routing_procedure_id)
    end
    found.quantity_in += qty
    found.save!
  end

end
