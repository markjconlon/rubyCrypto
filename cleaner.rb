require 'csv'

previous_line = ["","","","",""]
File.open('profits.csv').each do |line|
  line_array = line.split(",")
  if ((line_array[0] && line_array[1]) != (previous_line[0] && previous_line[1])) && ((line_array[2] && line_array[3]) != (previous_line[2] && previous_line[3])) && line_array[4].to_f > 0.1
    previous_line = line_array
    line_array[5] = line_array[5].delete!("\n")
    p line_array
    CSV.open('cleaned.csv', 'a+') do |csv|
      csv << line_array
    end
  end
end
