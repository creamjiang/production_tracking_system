class ChangeCodeLengthToLongerForBoxLabels < ActiveRecord::Migration
  def self.up
  	change_column :box_labels, :code, :string, :limit => 255
  end

  def self.down
  end
end
