class GraphController < ApplicationController
  
  before_filter :authenticate_user
  
   def index
     
    respond_to do |wants|
      wants.html {
        @graph = open_flash_chart_object( 600, 300, url_for( :action => 'index', :format => :json ) )
      }
      wants.json { 
#        chart = OpenFlashChart.new( "MY TITLE" ) do |c|
#          c << BarGlass.new( :values => (1..10).sort_by{rand} )
#        end

        title = Title.new("Pie Chart Example For Chipster")

        pie = Pie.new
        pie.start_angle = 35
        pie.animate = true
        pie.tooltip = '#val# of #total#<br>#percent# of 100%'
        pie.colours = ["#d01f3c", "#356aa0", "#C79810"]
        pie.values  = [2,3, PieValue.new(6.5,"Hello (6.5)")]
    
        chart = OpenFlashChart.new
        chart.title = title
        chart.add_element(pie)
    
        chart.x_axis = nil

        render :text => chart, :layout => false
      }
    end
  end

  
  def graph
    respond_to do |wants|
      wants.html {
      if params[:id].to_i == 1
        @graph = open_flash_chart_object( 800, 350, url_for( :action => 'pie', :format => :json ) )
      elsif params[:id].to_i == 2
        @graph = open_flash_chart_object(800,350, url_for( :action => 'bar') )
      end
    
      }

    end
  
  end
 
  def pie
    respond_to do |wants|
    
      wants.json { 
#        chart = OpenFlashChart.new( "MY TITLE" ) do |c|
#          c << BarGlass.new( :values => (1..10).sort_by{rand} )
#        end

        title = Title.new("Daily Pie Chart Machine-" + @machine.machine_number + " for " + Date.today.to_s )

        pie = Pie.new
        pie.start_angle = 35
        pie.animate = true
        pie.tooltip = '#val# of #total#<br>#percent# of 100%'
        pie.colours = ["#d01f3c", "#356aa0", "#C79810"]
      
        success = ProcedureTransaction.success(get_the_actual_date).select {|c| c.machine_id = @machine.id}
        reject  = ProcedureTransaction.reject(get_the_actual_date).select {|d| d.machine_id = @machine.id}
        
        success_value = PieValue.new(success.size.zero? ? 0 : success.size, 'Good Unit')
        reject_value  = PieValue.new(reject.size.zero? ? 0 : reject.size,  'Reject Unit')
        
        pie.values  = [reject_value, success_value]
    
        chart = OpenFlashChart.new
        chart.title = title
        chart.add_element(pie)
    
        chart.x_axis = nil

        render :text => chart, :layout => false
      }
    end
  end
  
  def bar
    bars   = []

    # random colors to chose from
    colours = ["#459a89", "#356aa0"]
   
    # the results
    success = ProcedureTransaction.success(get_the_actual_date).select {|c| c.machine_id = @machine.id}
    reject  = ProcedureTransaction.reject(get_the_actual_date).select {|d| d.machine_id = @machine.id}
        

    # group by subject and use subject as the key
    
      # 3d bar graph, could be any bar graph though
      bar = BarGlass.new
      bar.set_key("Accept", 3)
      bar.colour = "#459a89"
      bar_values = []
      a = BarValue.new(success.size.zero? ? 0 : success.size)
      b = BarValue.new(reject.size.zero? ? 0 : reject.size)
      total_size = success.size.to_i + reject.size.to_i 
      a.colour = "#30D030"
      b.colour = "#FF461F"
      bar_values << a
      bar_values << b
      bar.set_values(bar_values)
      
#      bar1 = BarGlass.new
#      bar1.set_key("Reject", 3)
#      bar1.colour = "#C79810"
#      bar_values = []
#      bar_values << BarValue.new(reject.size)
#      bar1.set_values(bar_values)
      
      
 
    # some title
    title = Title.new("Daily Chart Machine-" + @machine.machine_number + " for " + Date.today.to_s)

    # labels along the x axis, just hard code for now, but you would want to dynamically do this
    x_axis = XAxis.new
    x_axis.labels = ["Accept", "Reject"]

    # go to 100% since we are dealing with test results
    y_axis = YAxis.new
    case total_size.to_i
      when (0..10) 
        y_axis.set_range(0, 10, 1)
      when (11..20)
        y_axis.set_range(0, 20, 2)
      when (21..30)
        y_axis.set_range(0, 30, 2)
      when (31..50)
        y_axis.set_range(0, 50, 5)
      when (51..71)
        y_axis.set_range(0, 70, 5)
      when (71..100)
        y_axis.set_range(0, 100, 10)
      end

    # y_axis.set_range(0, 100, 10)
     
    # setup the graph
    graph = OpenFlashChart.new
    graph.bg_colour = '#ffffcc'
    graph.title = title
    graph.x_axis = x_axis
    graph.y_axis = y_axis
    graph.add_element(bar)
#    graph.add_element(bar1)
 
    render :text => graph.to_s, :layout => false
  end

end
