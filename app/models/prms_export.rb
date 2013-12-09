class PrmsExport < ActiveRecord::Base
  self.record_timestamps = false
  has_many :export_items
  belongs_to :administrator
  has_attached_file :document


  validates_presence_of :export_date

  before_create :change_create_timezone
  before_update :change_update_timezone
  
  EXCLUDE_REJECT = [ProcedureTransaction::GOOD, ProcedureTransaction::GOOD2]
  INCLUDE_REJECT = [ProcedureTransaction::GOOD, ProcedureTransaction::GOOD2, ProcedureTransaction::REJECT, ProcedureTransaction::REJECT2]

  def update_item(item)
    item.each do |item_id, content|
      found = export_items.find(item_id)
      found.export_quantity = content[:export_quantity].to_i
      found.destination_id = content[:destination_id]
      found.save(false)
    end
  end

  def import_items(item)
    item.each do |item_id, content|
      found = ProductBalance.find(item_id)
      acc = AccountStatement.first(:conditions => ["routing_procedure_id = ? and product_id = ? and account_month = ? and account_year = ?", found.routing_procedure_id, found.product_id, export_date.month, export_date.year])
      if acc
        acc_id = acc.id
      else
        acc_id = 0
      end
      export_items.create!(:account_statement_id => acc_id, :routing_procedure_id => found.routing_procedure_id, :warehouse_id => content[:warehouse_id].to_i, :destination_id => content[:destination_id].to_i, :product_id => found.product_id, :export_quantity => content[:quantity].to_i, :stock_quantity => content[:stock_quantity].to_i)
    end
  end

  def generate_file(admin)

    if export_items.first(:conditions => "stock_quantity < export_quantity")
      return false
    else
      if export_items.first(:conditions => "export_quantity < 0")
        return false
      else
        export_filename = "SCANIN"
        FileUtils.mkdir_p(RAILS_ROOT + '/public/system/documents/' + id.to_s + '/original')
        path = RAILS_ROOT + '/public/system/documents/' + id.to_s + '/original/' + export_filename + '.txt'
        FileUtils.touch(path)
        #FileUtils.chmod 0777, path
        File.open(path, 'w') do |f2|
          export_items.all(:conditions => "export_quantity > 0").each do |i|

            transaction do
              #ProcedureTransaction.update_all({:export_item_id => i.id}, ["routing_procedure_id = ? and product_id = ? and account_statement_id = ? and export_item_id = 0", i.routing_procedure_id, i.product_id, i.account_statement_id], {:limit => i.export_quantity})
#              if i.routing_procedure.reject_include?
#                t_items = ProcedureTransaction.all(:conditions => ["routing_procedure_id = ? and product_id = ? and account_statement_id = ? and status IN (?) and balance > 0", i.routing_procedure_id, i.product_id, i.account_statement_id, PrmsExport::INCLUDE_REJECT])
#              else
#                t_items = ProcedureTransaction.all(:conditions => ["routing_procedure_id = ? and product_id = ? and account_statement_id = ? and status IN (?) and balance > 0", i.routing_procedure_id, i.product_id, i.account_statement_id, PrmsExport::EXCLUDE_REJECT])
#              end
#              count = 0
#              t_items.each do |ti|
#                if count < i.export_quantity
#                  if (count + ti.balance) == i.export_quantity
#                    rest = ti.balance
#                    ti.balance -= ti.balance
#                    ti.save!
#                    ti.flush_accounts.create!(:export_item_id => i.id, :quantity => rest)
#                    count += rest
#
#                  elsif (count + ti.balance) > i.export_quantity
#                    ti.balance -= (i.export_quantity - count)
#                    ti.save!
#                    ti.flush_accounts.create!(:export_item_id => i.id, :quantity => (i.export_quantity - count))
#                    count += (i.export_quantity - count)
#
#                  elsif (count + ti.balance) < i.export_quantity
#                    rest = ti.balance
#                    ti.balance -= ti.balance
#                    ti.save!
#                    ti.flush_accounts.create!(:export_item_id => i.id, :quantity => rest)
#                    count += rest
#                  end
#                end
#              end

              i.transfered_quantity = i.export_quantity
              i.posted = true
              i.save(false)
              i.update_balance
              output_word = ""
                part = (i.product.part_number.strip)
              output_word << part[0,15]
              rest_len = 15 - part[0,15].length
              output_word << " " * rest_len if rest_len > 0
                part = (i.product.description.strip)
              output_word << part[0,30]
              rest_len = 30 - part[0,30].length
              output_word << " " * rest_len if rest_len > 0
                part = (i.warehouse.name.strip)
              output_word << part[0,3]
              rest_len = 3 - part[0,3].length
              output_word << " " * rest_len if rest_len > 0
                part = (admin.employee_number.strip)
              output_word << part[0,10]
              rest_len = 10 - part[0,10].length
              output_word << " " * rest_len if rest_len > 0
                part = "TscSys"
              output_word << part[0,8]
              rest_len = 8 - part[0,8].length
              output_word << " " * rest_len if rest_len > 0
                part = i.export_quantity.to_s
              output_word << part[0,12]
              rest_len = 12 - part[0,12].length
              output_word << " " * rest_len if rest_len > 0
                part = Date.today.strftime("%y") + Engineer.calculate_number(i.id, 5)
              output_word << part[0,12]
              rest_len = 12 - part[0,12].length
              output_word << " " * rest_len if rest_len > 0
              if i.destination.name == "x"
                part = "P"
              else
                part = "S"
              end
              output_word << part[0,13]
              rest_len = 13 - part[0,13].length
              output_word << " " * rest_len if rest_len > 0
                part = export_date.strftime("%d/%m/%y")
              output_word << part[0,8]
              rest_len = 8 - part[0,8].length
              output_word << " " * rest_len if rest_len > 0
              if i.destination.name == "x"
                part = ""
              else
                part = i.destination.name
              end
              output_word << part[0,2]
              rest_len = 2 - part[0,2].length
              output_word << " " * rest_len if rest_len > 0
              if i.destination.name == "x"
                part = ""
              else
                part = i.destination.location
              end
              output_word << part[0,4]
              rest_len = 4 - part[0,4].length
              output_word << " " * rest_len if rest_len > 0
                part = (i.warehouse.location.strip)
              output_word << part[0,4]
              rest_len = 4 - part[0,4].length
              output_word << " " * rest_len if rest_len > 0


              f2.puts output_word + "\r\n"
            end
          end
        end

        self.document_file_name = export_filename + '.txt'
        self.document_file_size = File.size(path)
        self.document_content_type = "text/plain"
        self.document_updated_at = Time.now
        self.posted = true
        save(false)
      end
    end
    
  end

  def verify_destroy
    unless posted?
      destroy
      return true
    else
      return false
    end
  end

  private
  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end
  
  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end


end
