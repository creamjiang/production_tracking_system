class LabelEngine

  def initialize(box_label)
  	@box_label = box_label
  	@side      = @box_label.side
    @machine   = @box_label.machine
    mounted_root_path = "/mnt/barcode"
  	case @side
  	when "Left"
  	  @commander_triggering_path = "#{mounted_root_path}/#{@machine.scan_folder}/left_#{@box_label.id}.txt"
  	when "Right"
  	  @commander_triggering_path = "#{mounted_root_path}/#{@machine.scan_folder}/right_#{@box_label.id}.txt"
  	when "Common"
  	  @commander_triggering_path = "#{mounted_root_path}/#{@machine.scan_folder}/common_#{@box_label.id}.txt"
  	end
  	@date = @box_label.boxed_date_time.strftime("%d-%m-%Y")
  	@time = @box_label.boxed_date_time.strftime("%H:%M")
  end

  def generate_label_content
  	 File.open(@commander_triggering_path, "w") do |f2|
  	   f2.puts "#{@box_label.code},#{@box_label.part_number},#{@box_label.description},#{@box_label.machine_number},#{@box_label.quantity},#{@date},#{@time},#{@box_label.employee_name}"
  	 end
  end

end