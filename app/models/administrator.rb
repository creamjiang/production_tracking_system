class Administrator < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :group
  has_many :procedure_admins
  has_many :routing_procedures, :through => :procedure_admins
  has_many :routing_processes, :through => :routing_procedures
  has_many :prms_exports
  

  delegate :name, :alias, :description, :builtin, :position, :to => :group, :prefix => true
  
  attr_accessible :name, :login, :remark, :group_id, :employee_number
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  validates_presence_of :employee_number, :login, :name
  validates_uniqueness_of :login
  
  before_create :change_create_timezone
  before_update :change_update_timezone

  def routing_procedures_products
    result = []
    products_ids = []
    routing_procedures.each do |r|
      r.attached_products.each do |p|
        unless products_ids.include?(p.product_id)
          products_ids << p.product_id
          result << p
        end
      end
    end
    result.sort_by { |c| c.part_name }
  end

  def routing_procedures_on_hold_products
    result = []
    products_ids = []
    routing_procedures.each do |r|
      r.attached_products.each do |p|
        if ColdStore.product_quantity(p.product_id) > 0
          products_ids << p.product_id
          result << p
        end unless products_ids.include?(p.product_id)
      end
    end
    result.sort_by { |c| c.part_name }
  end

  def stocks
#    result = []
#    pro_ids = procedure_admins.collect(&:routing_procedure_id).sort
#    RoutineProduct.all(:conditions => ["routing_procedure_id IN (?) and warehouse_id > 0", pro_ids]).each do |i|
#      found = ProductBalance.first(:conditions => ["routing_procedure_id = ? and product_id = ? and balance > 0", i.routing_procedure_id, i.product_id])
#      result << found if found
#    end
#    result
     ProductBalance.find_by_sql("SELECT * FROM `product_balances` where routing_procedure_id IN (SELECT routing_procedure_id FROM `routine_products` where routing_procedure_id IN (SELECT routing_procedure_id  FROM `procedure_admins` where `administrator_id` = #{id}) and warehouse_id > 0) and balance > 0")
  end

  def exception_procedures
    result = []
    RoutingProcedure.all.each do |r|
      unless routing_procedures.include?(r)
        result << r
      end
    end
    result
  end
  
  def verify_destroy
    
    if procedure_admins.size.zero?
      checked = true
      destroy
      msg = "Successfully destroy"
    else
      checked = false
      msg = "The administrator has attached procedure, please remove them first"
    end
    return checked, msg
  end
  
  def belongs_machines(targets)
    result = []
    
    routing_procedures.each do |rp|
      rp.machines.each do |m|
        result << m if targets.include?(m)
      end
    end
    result.sort_by {|c| c.machine_number}
  end
  
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    create_new_salt
    self.hashed_password = self.class.crypt_password(self.password, self.salt)
  end

  def validate_on_create
    if @password.length < 6
      errors.add(:password, "password cannot be less than 6 characters")
    end
  end

  def self.try_to_login(login, password)
   user = self.find_by_login(login)
    if user
      hash_password = self.crypt_password(password, user.salt)
      user.hashed_password == hash_password ? user : false
    else
      return false
    end
  end

    private

  def self.crypt_password(password, salt)
    string_to_hash = password + "aUtOmoTivE" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + [Array.new(6){rand(256).chr}.join].pack("m").chomp
  end
  
  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end
  
  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end


end
