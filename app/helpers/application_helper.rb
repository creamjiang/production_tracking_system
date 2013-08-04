# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def redirect_to_clear_bin_method_for_bin
    setting = Setting.first
    if setting.register_bin_with_scanner
      link_to "clear bin", clear_bins_path
    else
      link_to "clear bin", list_bin_types_bins_path 
    end
  end
  
  def get_mac_address

    if RUBY_PLATFORM =~ /win/ && !(RUBY_PLATFORM =~ /darwin/)
      begin
        ifconfig_output = `ipconfig /all`
        mac_addresses = ifconfig_output.scan(
          Regexp.new("(#{(["[0-9A-F]{2}"] * 6).join("-")})"))
        if mac_addresses.size > 0
          return mac_addresses.first.first.downcase.gsub(/-/, ":")
        end
      rescue
      end
    else
      begin
        ifconfig_output = `ifconfig`
        mac_addresses = ifconfig_output.scan(
          Regexp.new("ether (#{(["[0-9a-fA-F]{2}"] * 6).join(":")})"))
        if mac_addresses.size == 0
          ifconfig_output = `ifconfig | grep HWaddr | cut -c39-`
          mac_addresses = ifconfig_output.scan(
            Regexp.new("(#{(["[0-9a-fA-F]{2}"] * 6).join(":")})"))
        end
        if mac_addresses.size == 0
          ifconfig_output = `/sbin/ifconfig`
          mac_addresses = ifconfig_output.scan(
            Regexp.new("ether (#{(["[0-9a-fA-F]{2}"] * 6).join(":")})"))
        end
        if mac_addresses.size == 0
          ifconfig_output = `/sbin/ifconfig | grep HWaddr | cut -c39-`
          mac_addresses = ifconfig_output.scan(
            Regexp.new("(#{(["[0-9a-fA-F]{2}"] * 6).join(":")})"))
        end
        if mac_addresses.size > 0
          return mac_addresses.first.first
        end
      rescue
      end
    end
   end

end
