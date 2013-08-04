class AddNewRecordToGroups < ActiveRecord::Migration
  def self.up

    found = Group.find(3) rescue nil
    unless found
      group = Group.new
      group.name = "Report Viewer"
      group.builtin = 1
      group.position = 1
      group.id = 3
      group.save!
    end

    found = Group.find(4) rescue nil
    unless found
      group = Group.new
      group.name = "Material Input"
      group.builtin = 1
      group.position = 2
      group.id = 4
      group.save!
    end

    found = Group.find(5) rescue nil
    unless found
      group = Group.new
      group.name = "PRMS Admin"
      group.builtin = 1
      group.position = 2
      group.id = 5
      group.save!
    end
  end

  def self.down
    
  end
end
