class Employee < ActiveRecord::Base
  self.record_timestamps = false
  belongs_to :department
  has_many :operators
  has_many :machines, :through => :operators
  has_many :working_states
  has_many :procedure_transactions
  has_many :bin_clearing_records
  has_many :machine_downtimes
  has_many :login_records
  has_many :transaction_summaries
  has_many :box_labels

  attr_accessible :name, :remark, :department_id
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  
  before_create :change_create_timezone
  before_update :change_update_timezone

  def belongs_machines(targets)
    result = []
    search = machines
    targets.each do |t|
      result << t if search.include?(t)
    end
    result.sort_by {|c| c.machine_number}
  end
  
  def related_machines_operator_login(login_records)
    selected_login_records = []
    machines.each do |m|
      for emp in m.employees
        interset = login_records.select {|lr| lr.employee_id == emp.id and lr.machine_id == m.id and lr.logout == false}
        interset.each {|i| selected_login_records << i unless selected_login_records.include?(i)}
      end
    end
    #selected_login_records.flatten.uniq
    selected_login_records
  end
  
  def belonging_employees
    selected_employees = []
    machines.each do |m|
      for emp in m.employees
        selected_employees << emp unless selected_employees.include?(emp)
      end
    end
    
    selected_employees
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
  
  def belonging_bin_types
    bintypes = []
    belonging_products = []
    machines.each {|m| m.products.each do |mp|
                         belonging_products << mp
                       end
      }
    
    belonging_products.flatten.uniq!
    belonging_products.each do |p|
      p.containers.each {|c| 
                         unless bintypes.include?(c.bin_type)
                            bintypes << c.bin_type
                         end
           }  
    end
    
    #bintypes.flatten.uniq!
    bintypes
  
  end
  
  def generate_reject_report(from, to)
    transactions = []
    machines.each {|c| transactions << c.reject_report(from, to) }
    transactions.flatten!
    transactions
  end
  
  def verify_for_destroy
   deleted = false
      if bin_clearing_records.size.zero?
        if working_states.size.zero?
          if procedure_transactions.size.zero?
            if machine_downtimes.size.zero?
              if operators.size.zero?
                if routing_procedures.size.zero?
                  destroy
                  deleted = true
                end
              end
            end
          end
        end
      end
    
    deleted
  end
  
  def add_login_record(machine_id)
    login_records.create(:machine_id => machine_id)
  end
  
  def update_login_record(machine_id)
    login = login_records.first(:conditions => ["machine_id = ? and logout = false", machine_id])
    if login
      login.logout = true
      login.save!
    end
  end
  
  
  def password
    @password
  end

  def self.try_to_login(login, password, machine_id)
   user = self.find_by_employee_number(login)
    if user
      #if user.machines.first(:conditions => ["machine_id = ?", machine_id.to_i])
      found = user.machines.find(machine_id.to_i) rescue nil 
       if found
                 
            hash_password = self.crypt_password(password, user.salt)
            if user.hashed_password == hash_password
               if user.login_records.all(:conditions => ["logout = false"]).size.zero?
                 user
               else
                 existing_login = user.login_records.first(:conditions => ["logout = false and machine_id != ?", machine_id])
                 if existing_login
                   LoginRecord::LOGIN_FREEZED
               
                 else
                   previous_login = user.login_records.first(:conditions => ["logout = false and machine_id = ?", machine_id])
                   
                   if previous_login
                     previous_login.logout = true
                     previous_login.save!
                     user
                   else
                     user
                   end
                     
                 end #existing login
                 
               end # if user dont have any login records
             else
                LoginRecord::INVALID_PASSWORD
             end #check password
      else
        LoginRecord::INVALID_MACHINE  
      end #if found
    else
      LoginRecord::INVALID_LOGIN
    end
  end
  
  def self.supervisor_try_to_login(login, password)
   user = self.find_by_employee_number(login)
    if user and user.department_id.eql?(Department::SUPERVISOR)
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
