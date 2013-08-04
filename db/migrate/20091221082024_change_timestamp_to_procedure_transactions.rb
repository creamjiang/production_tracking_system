class ChangeTimestampToProcedureTransactions < ActiveRecord::Migration
  def self.up
     
     ProcedureTransaction.all.each do |p|  
       p.update_attribute :created_at, p.created_at + 8.hours  
     end  
  end

  def self.down
    p.update_attribute :created_at, p.created_at - 8.hours 
  end
end
