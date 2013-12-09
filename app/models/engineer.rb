class Engineer

  def self.long_run
    i = true
    while i
      Product.all.each do |p|
        puts p.part_number + "\n" rescue "None\n"
      end
    end
  end

  def self.calculate_number(num, digit)
    bal = digit.to_i - num.to_s.length
    "0" * bal + num.to_s
  end

  def self.negative(num)
    if num.to_i > 0
      return num - (num * 2)
    else
      return num
    end
  end

  def self.generate_box_label_code
    last_box_label = BoxLabel.last
    first_section_code = Time.now.strftime("%y%m%d")
    if last_box_label
      if last_box_label.boxed_date_time.to_date == Date.today
        running_num = last_box_label.code.split("-")[1].to_i + 1
      elsif last_box_label.boxed_date_time.to_date < Date.today
        running_num = 1
      end
    else
      running_num = 1
    end
    second_section_code = running_num.to_s.rjust(5, "0")
    first_section_code + "-" + second_section_code
  end
  
end