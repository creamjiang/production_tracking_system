class LabelEngine

  def initialize(box_label)
  	@box_label = box_label
  	@side      = @box_label.side
    @machine   = @box_label.machine
    @mounted_root_path = "/mnt/windowseven"
    @scan_path = "#{@mounted_root_path}/#{@machine.scan_folder}"
    system "ls /mnt/windowseven"
    directories = Dir.entries(@mounted_root_path)
    result = directories.reject {|d| d =~ /\.+/ }
    if result.blank?
      system "mount.cifs //10.102.224.191/BarcodeScan /mnt/windowseven -o user=cbk8pg2,password=ALPenang6*"
    end

  	# case @side
  	# when "Left"
  	#   @commander_triggering_path = "#{@scan_path}/left_#{@box_label.id}.txt"
  	# when "Right"
  	#   @commander_triggering_path = "#{@scan_path}/right_#{@box_label.id}.txt"
  	# when "Common"
  	#   @commander_triggering_path = "#{@scan_path}/common_#{@box_label.id}.txt"
  	# end
    case @side
    when "Left"
      @side_code = "LH"
    when "Right"
      @side_code = "RH"
    when "Common"
      @side_code = "CMN"
    end
    @commander_triggering_path = "#{@scan_path}/#{@box_label.id}.txt"
    label_datetime = @box_label.boxed_date_time
  	@date = label_datetime.strftime("%d-%m-%Y")
  	@time = label_datetime.strftime("%H:%M")
  end

  def generate_label_content
    directories = Dir.entries(@mounted_root_path)
    result = directories.reject {|d| d =~ /\.+/ }
    unless result.blank?
  	  File.open(@commander_triggering_path, "w") do |f2|
  	    f2.puts "#{@box_label.code},#{@box_label.part_number},#{@box_label.description},#{@box_label.machine_number},#{@box_label.quantity},#{@date},#{@time},#{@box_label.employee_number},#{@side_code},#{@box_label.code[-10..-1]}"
  	  end
    end
  end

end