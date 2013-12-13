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

  def self.generate_box_label_code(part_number, actual_date, qty)
    setting = Setting.first
    setting.lock!
    setting.last_label_running_number += 1
    setting.save!
    running_num = setting.last_label_running_number

    running_num = running_num.to_s.rjust(4, "0")
    qty = qty.to_s.rjust(4, "0")
    part_number = part_number.ljust(15, " ")
    last_section_code = "#{actual_date}#{running_num}"
    "#{part_number}#{qty}#{last_section_code}"
  end
  
end