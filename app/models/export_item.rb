class ExportItem < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :prms_export
  belongs_to :routing_procedure
  belongs_to :product
  belongs_to :account_statement
  belongs_to :destination
  belongs_to :warehouse
  has_many   :flush_accounts
  has_many   :procedure_transactions, :through => :flush_accounts

  before_create :change_create_timezone
  after_update :change_update_timezone
  before_create :check_ids

  def update_balance
    ac = account_statement
    unless ac
      export_date = prms_export.export_date
      ac = product.account_statements.first(:conditions => ["routing_procedure_id = ? and account_month = ? and account_year = ?", routing_procedure_id, export_date.to_date.month, export_date.to_date.year])
      unless ac

        ac = product.account_statements.new(:routing_procedure_id => routing_procedure_id, :account_month => export_date.to_date.month, :account_year => export_date.to_date.year)
        found = product.account_statements.last(:conditions => ["routing_procedure_id = ? and account_month < ? and account_year <= ?", routing_procedure_id, export_date.to_date.month, export_date.to_date.year], :order => "account_year, account_month")
        ac.opening_balance = found.closing_balance if found
        ac.save(false)
      end
      found = product.account_statements.all(:conditions => ["routing_procedure_id = ? and account_month >= ? and account_year > ?", routing_procedure_id, export_date.to_date.month, export_date.to_date.year], :order => "account_year, account_month")
      @balance = ac.closing_balance
      found.each do |f|
        f.opening_balance = @balance
        f.save(false)
        @balance = f.closing_balance
      end
      self.account_statement = ac
      save(false)
    end

      ac.lock!
      ac.quantity_out += transfered_quantity
      ac.save(false)
      found = ProductBalance.first(:conditions => ["routing_procedure_id = ? and product_id = ?", routing_procedure_id, product_id])
      found = ProductBalance.new(:routing_procedure_id => routing_procedure_id, :product_id => product_id) unless found
      found.quantity_out += transfered_quantity
      found.save(false)
      
    
  end

  def is_valid_quantity?
    export_quantity <= stock_quantity and export_quantity >= 0
  end

  private



  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end

  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end

  def check_ids
    self.routing_process_id = routing_procedure.routing_process_id if routing_procedure
    self.routing_id = routing_procedure.routing_id if routing_procedure
  end
end
