class BinType < ActiveRecord::Base
  self.record_timestamps = false
  has_many :bins
  has_many :containers, :include => :product, :order => "products.part_number"
  has_many :products ,:through => :containers 
  has_many :procedure_transactions
  has_many :machine_downtimes
  has_many :working_states
  has_many :attached_products
  has_many :routine_products
  
  #attr_accessible :name, :description
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :maximum_load
  
  before_create :change_create_timezone
  before_update :change_update_timezone

  BARCODE_FORMATS = [

    "BARCODE_128"

  ]

  def generate_image(item)
    if item
      output_name = item.part_number.delete(" ")
      check_format(product_barcode_format, output_name)
    else
      output_name = bin_barcode_text.delete(" ") rescue "NOTEXT"
      check_format(bin_barcode_format, output_name)
    end
    f = File.new(RAILS_ROOT + "/public/images/barcodes/#{output_name}.png", "wb")
    f.write @barcode.to_png(:margin => 1)
    f.close
    "barcodes/#{output_name}.png"
  end

#  BARCODE_FORMATS = [
#    "BARCODE_ANY",
#    "BARCODE_EAN",
#    "BARCODE_UPC",
#    "BARCODE_ISBN",
#    "BARCODE_128B",
#    "BARCODE_128C",
#    "BARCODE_128",
#    "BARCODE_128RAW",
#    "BARCODE_39",
#    "BARCODE_I25",
#    "BARCODE_CBR",
#    "BARCODE_MSI",
#    "BARCODE_PLS",
#    "BARCODE_93",
#    "BARCODE_NO_CHECKSUM"
#  ]

#  def product_encoding_format
#    case product_barcode_format
#    when "BARCODE_ANY"
#      Gbarcode::BARCODE_ANY
#    when "BARCODE_EAN"
#      Gbarcode::BARCODE_EAN
#    when "BARCODE_UPC"
#      Gbarcode::BARCODE_UPC
#    when "BARCODE_ISBN"
#      Gbarcode::BARCODE_ISBN
#    when "BARCODE_128B"
#      Gbarcode::BARCODE_128B
#    when "BARCODE_128C"
#      Gbarcode::BARCODE_128C
#    when "BARCODE_128"
#      Gbarcode::BARCODE_128
#    when "BARCODE_128RAW"
#      Gbarcode::BARCODE_128RAW
#    when "BARCODE_39"
#      Gbarcode::BARCODE_39
#    when "BARCODE_I25"
#      Gbarcode::BARCODE_I25
#    when "BARCODE_CBR"
#      Gbarcode::BARCODE_CBR
#    when "BARCODE_MSI"
#      Gbarcode::BARCODE_MSI
#    when "BARCODE_PLS"
#      Gbarcode::BARCODE_PLS
#    when "BARCODE_93"
#      Gbarcode::BARCODE_93
#    when "BARCODE_NO_CHECKSUM"
#      Gbarcode::BARCODE_NO_CHECKSUM
#    end
#  end
#
#  def bin_encoding_format
#    case bin_barcode_format
#    when "BARCODE_ANY"
#      Gbarcode::BARCODE_ANY
#    when "BARCODE_EAN"
#      Gbarcode::BARCODE_EAN
#    when "BARCODE_UPC"
#      Gbarcode::BARCODE_UPC
#    when "BARCODE_ISBN"
#      Gbarcode::BARCODE_ISBN
#    when "BARCODE_128B"
#      Gbarcode::BARCODE_128B
#    when "BARCODE_128C"
#      Gbarcode::BARCODE_128C
#    when "BARCODE_128"
#      Gbarcode::BARCODE_128
#    when "BARCODE_128RAW"
#      Gbarcode::BARCODE_128RAW
#    when "BARCODE_39"
#      Gbarcode::BARCODE_39
#    when "BARCODE_I25"
#      Gbarcode::BARCODE_I25
#    when "BARCODE_CBR"
#      Gbarcode::BARCODE_CBR
#    when "BARCODE_MSI"
#      Gbarcode::BARCODE_MSI
#    when "BARCODE_PLS"
#      Gbarcode::BARCODE_PLS
#    when "BARCODE_93"
#      Gbarcode::BARCODE_93
#    when "BARCODE_NO_CHECKSUM"
#      Gbarcode::BARCODE_NO_CHECKSUM
#    end
#  end

  
  def exception_products(selected_products)
    result = []
    selected_products.each do |p|
      unless products.include?(p)
        result << p
      end
    end
    result
  end
  
  def self.collect_bins(bin_type)
    #bin_types = BinType.all
    #bin_types_selected = bin_types.select {|c| c.products.include?(product)}
    bins = []
    bins << bin_type.bins.select {|f| f.bin_status_id == BinStatus::AVAILABLE }
    bins.flatten!
    #sorted_bin = bins.sort_by {|e| e.bin_type_id}
    #sorted_bin
    
  end
  
  def verify_for_destroy
   deleted = false
      if bins.size.zero?
        if containers.size.zero?
          if procedure_transactions.size.zero?
            if machine_downtimes.size.zero?
              destroy
              deleted = true
            end
          end
        end
      end
    
    deleted
  end
  
   private

  def check_format(format, output)
    require 'barby'
    require 'barby/outputter/rmagick_outputter'
    begin
      case format
      when "BARCODE_EAN13"
        @barcode = Barby::EAN13.new(output)
      when "BARCODE_EAN8"
        @barcode = Barby::EAN8.new(output)
      when "BARCODE_128"
        @barcode = Barby::Code128B.new(output)
      when "BARCODE_128A"
        @barcode = Barby::Code128A.new(output)
      when "BARCODE_128B"
        @barcode = Barby::Code128B.new(output)
      when "BARCODE_128C"
        @barcode = Barby::Code128C.new(output)
      when "BARCODE_25"
        @barcode = Barby::Code25.new(output)
      when "BARCODE_39"
        @barcode = Barby::Code39.new(output)
      when "BARCODE_93"
        @barcode = Barby::Code93.new(output)
      end
    rescue
      @barcode = Barby::Code128B.new(output)
    end
  end

  def change_create_timezone
    self.created_at = Time.now + 8.hours
    self.updated_at = Time.now + 8.hours
  end
  
  def change_update_timezone
    self.updated_at = Time.now + 8.hours
  end
  
  
end
