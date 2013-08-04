# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class PrmsGenerator

  def self.call(env)
      session = env["rack.session"]
      req = Rack::Request.new(env)
      @params = req.params
       
      if env["PATH_INFO"] =~ /^\/prms_generator/
        if session[:admin_id]
       
          last_export =  PrmsExport.connection.select_all("SELECT * FROM prms_exports").last  
          p_transactions = ProcedureTransaction.find_by_sql(["SELECT routing_procedure_id, machine_id, routing_process_id, generic_name, product_id, employee_id, COUNT(*) as num_quantity FROM procedure_transactions WHERE created_at >= '#{last_export["export_from"]}' and created_at <= '#{last_export["export_to"]}' and status IN (1, 4)  GROUP BY routing_procedure_id, machine_id, routing_process_id, generic_name"])
      
          for item in p_transactions
            if PrmsItem.connection.select_all("SELECT * FROM prms_items WHERE prms_export_id = #{last_export["id"]} and routing_process_id =  #{item["routing_process_id"]} and product_id = #{item["product_id"]} and routing_procedure_id = #{item["routing_process_id"]} and machine_id = #{item["machine_id"]} and employee_id = #{item["employee_id"]}").empty?
              sql = "INSERT INTO prms_items (prms_export_id, routing_process_id, product_id, routing_procedure_id, machine_id, employee_id, quantity, balance) VALUES(#{last_export["id"]}, #{item["routing_process_id"]}, #{item["product_id"]}, #{item["routing_procedure_id"]}, #{item["machine_id"]}, #{item["employee_id"]}, #{item["num_quantity"]}, #{item["num_quantity"]});"
              ActiveRecord::Base.connection.execute(sql)
            end
          end
    
          #[200, {"Content-Type" => "text/html"}, ["Hello, World!" + session[:admin_id].to_s]]
          [302, {"Content-Type" => "text/html", "Location" => "/prms_exports/#{last_export["id"].to_s}"}, ["You are being redirected."]]
        else
          [302, {"Content-Type" => "text/html", "Location" => "/login/logout"}, ["Authentication Failed."]]
        end
     
      else
        [404, {"Content-Type" => "text/html"}, ["Not Found"]]
      end
  end
  
  
end
