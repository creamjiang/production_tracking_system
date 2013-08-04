class AddDocumentDetailToPrmsExport < ActiveRecord::Migration
  def self.up
    add_column :prms_exports, :document_file_name,    :string
    add_column :prms_exports, :document_content_type, :string
    add_column :prms_exports, :document_file_size,    :integer
    add_column :prms_exports, :document_updated_at,   :datetime
  end

  def self.down
    remove_column :prms_exports, :document_file_name,    :string
    remove_column :prms_exports, :document_content_type, :string
    remove_column :prms_exports, :document_file_size,    :integer
    remove_column :prms_exports, :document_updated_at,   :datetime
  end
end
