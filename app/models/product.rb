class Product < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :category
  has_many :containers
  has_many :bins, :through => :containers
  has_many :working_states
  has_many :procedure_transactions
  has_many :machine_downtimes
  has_many :attached_products
  has_many :machines, :through => :attached_products
  has_many :transaction_summaries
  has_many :cold_stores
  has_many :cold_store_account
  #has_many :routing_processes
  #has_many :routing_processes, :through => :procedure_products
  has_many :daily_transactions
  has_many :account_statements
  has_many :export_items
  has_many :efficiency_schedules
  has_many :product_balances
  has_many :routine_products
  has_many :box_labels
  
  has_attached_file :avatar, 
                    :styles => { :medium => "300x300>",
                                 :thumb => "100x100>" }

  attr_protected :id
  #validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], :message => "has to be in jpeg or gif or png format"
  validates_presence_of :part_number, :part_name
  validates_uniqueness_of :part_number
  
  attr_accessor :good_unit, :hold_unit, :reject_unit, :shift, :processing_date, :yesterday_good_unit, :yesterday_reject_unit, :yesterday_hold_unit
  attr_accessor :yesterday_transactions, :today_transactions
  
  before_create :change_create_timezone
  before_update :change_update_timezone

  LEFT = "Left"
  RIGHT = "Right"
  COMMON = "Common"
  
  SIDE_CHOICES = [
  ["Left", LEFT],
  ["Right", RIGHT],
  ["Common", COMMON]
  ].freeze
  
  THERMOPLASTIC = "ThermoPlastic"
  DURAPLAST = "Duraplast"
  
  TECH_CHOICES = [
  ["ThermoPlastic", THERMOPLASTIC],
  ["Duraplast", DURAPLAST]
  ].freeze
  

  
  def self.collect_products(user_id)
    employee = Employee.find(user_id)
    prods = []
    employee.machines.each do |m|
      m.products.each do |p|
        prods << p
      end
    end
    prods.sort_by {|c| c.part_number}
  end
  
  def verify_for_destroy
   deleted = false
     
        if containers.size.zero?
          if procedure_transactions.size.zero?
            if machine_downtimes.size.zero?
              if working_states.size.zero?
                destroy
                deleted = true
              end
            end
          end
        end
    
    deleted
  end
  
   def self.generate_summary(products, shift_id, processing_date, machine_id)
    products.each do |c|
#      summary = c.product.transaction_summaries.first(:conditions => ["shift_id = ? and machine_id = ? and processing_date = ?", shift_id, machine_id, processing_date])
#      yesterday_summary = c.product.transaction_summaries.first(:conditions => ["shift_id = ? and machine_id = ? and processing_date = ?", shift_id, machine_id, Date.parse(processing_date) - 1])
      c.product.today_transactions = c.product.transaction_summaries.all(:conditions => ["machine_id = ? and processing_date = ?", machine_id, processing_date], :order => "processing_date, shift_id")
      #yesterday_summary = c.product.transaction_summaries.all(:conditions => ["machine_id = ? and processing_date = ?", machine_id, Date.parse(processing_date) - 1], :order => "processing_date, shift_id")

      #c.product.yesterday_transactions = yesterday_summary

#      if summary
#        c.product.good_unit = summary.good_unit
#        c.product.hold_unit = summary.hold_unit
#        c.product.reject_unit = summary.reject_unit
#
#      else
#        c.product.good_unit = 0
#        c.product.hold_unit = 0
#        c.product.reject_unit = 0
#      end
#
#        if yesterday_summary
#          c.product.yesterday_good_unit = yesterday_summary.good_unit
#          c.product.yesterday_hold_unit = yesterday_summary.hold_unit
#          c.product.yesterday_reject_unit = yesterday_summary.reject_unit
#        else
#          c.product.yesterday_good_unit = 0
#          c.product.yesterday_hold_unit = 0
#          c.product.yesterday_reject_unit = 0
#        end
#
#        c.product.shift = Shift.find(shift_id).name rescue c.product.shift = "None"
#        c.product.processing_date = processing_date
    end
    products
  end
  
  def generate_yesterday_summary(shift_id, processing_date, machine_id)
    summary = transaction_summaries.first(:conditions => ["shift_id = ? and machine_id = ? and processing_date = ?", shift_id, machine_id, processing_date])
    yesterday_summary = transaction_summaries.first(:conditions => ["shift_id = ? and machine_id = ? and processing_date = ?", shift_id, machine_id, Date.parse(processing_date) - 1])
      if summary
        self.good_unit = summary.good_unit
        self.hold_unit = summary.hold_unit
        self.reject_unit = summary.reject_unit
        
      else
        self.good_unit = 0
        self.hold_unit = 0
        self.reject_unit = 0
      end 
    
      if yesterday_summary
         self.yesterday_good_unit = yesterday_summary.good_unit
         self.yesterday_hold_unit = yesterday_summary.hold_unit
         self.yesterday_reject_unit = yesterday_summary.reject_unit
      else
         self.yesterday_good_unit = 0
         self.yesterday_hold_unit = 0
         self.yesterday_reject_unit = 0
      end
  end
  
  def total_good_unit
    yesterday_good_unit + good_unit
  end
  
  def total_reject_unit
    yesterday_reject_unit + reject_unit
  end
  
  def total_hold_unit
    yesterday_hold_unit + hold_unit
  end

  def fullname
    part_number + "-" + part_name
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
