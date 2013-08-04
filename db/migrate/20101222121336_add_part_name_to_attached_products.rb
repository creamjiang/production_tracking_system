class AddPartNameToAttachedProducts < ActiveRecord::Migration
  def self.up
    add_column :attached_products, :part_name, :string

    AttachedProduct.all.each do |p|
      p.part_name = p.product.part_name
      p.save!
    end
  end

  def self.down
    remove_column :attached_products, :part_name
  end
end
