# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class DeadOrAlive
  
  
  def self.call(env)
 
    
    if env["PATH_INFO"] =~ /^\/dead_or_alive/
      
      last_export =  PrmsExport.connection.select_all("SELECT * FROM prms_exports").last
      
      [200, {"Content-Type" => "text/html"}, ["Hello " + last_export["export_from"]]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
