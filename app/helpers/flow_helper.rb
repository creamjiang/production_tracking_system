module FlowHelper
  
  def redirect_to_clear_bin_method
    setting = Setting.first
    if setting.register_bin_with_scanner
      link_to image_tag("clear_bin.png", :size => "80x80", :border => 0, :alt => "Clear Bin"), :action => "clear_bin"
    else
      link_to image_tag("clear_bin.png", :size => "80x80", :border => 0, :alt => "Clear Bin"), :action => "list_bin_types" 
    end
  end
  
  
  
end
