class AddReviewerToDepartments < ActiveRecord::Migration
  def self.up
    found = Department.find(Department::REVIEWER) rescue nil
    if found 
      unless found.name == "Reviewer" and found.builtin?
         
         d = Department.new
         d.name = found.name
         d.description = found.description
         d.alias = found.alias
         d.builtin = false
         d.save(false)
         
         found.employees.each do |c|
           c.department_id = d.id
           c.save!
         end
         
         found.name = "Reviewer"
         found.alias = "Reviewer"
         found.description = "Reviewer"
         found.builtin = true
         found.save!
         
      end
    else
      d = Department.new
      d.id = 4
      d.name = "Reviewer"
      d.alias = "Reviewer"
      d.description = "Reviewer"
      d.builtin = true
      d.save!
    end
  end

  def self.down
  end
end
