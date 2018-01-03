require 'csv'

previous_line = ["","","","","","","","",""]
File.open('index.csv').each do |line|
  line_array = line.split(",")
  # if ((line_array[0] && line_array[1]) != (previous_line[0] && previous_line[1])) && ((line_array[2] && line_array[3]) != (previous_line[2] && previous_line[3]))
  if (line_array[1] != previous_line[1] || line_array[2]!= previous_line[2] || line_array[3]!= previous_line[3] || line_array[4]!= previous_line[4])
    previous_line = line_array
    line_array[8] = line_array[8].delete!("\n")
    CSV.open('cleaned.csv', 'a+') do |csv|
      csv << line_array
    end
  end
end

delta1 = []
delta3 = []
delta5 = []
delta7 = []
sell_on_poloniex = 0
sell_on_liqui = 0
sell_on_quadrigacx = 0

File.open('cleaned.csv').each do |line|
  line_array = line.split(",")
  delta = line_array[1].to_f - (line_array[3].to_f * ((1 + 0.0025)/ ( 1 - 0.0026)))
  if delta >= 0.0007
    delta7 << delta
  elsif delta >= 0.0005
    delta5 << delta
  elsif delta >= 0.0003
    delta3 << delta
  else
    delta1 << delta
  end

  if line_array[0] == "sell_on_poloniex"
    sell_on_poloniex += 1
  elsif line_array[0] == "sell_on_liqui"
    sell_on_liqui += 1
  else
    sell_on_quadrigacx += 1
  end

end
puts "0.0007 has #{delta7.count} trades"
p delta7

puts "0.0005 has #{delta5.count} trades"
p delta5

puts "0.0003 has #{delta3.count} trades"
p delta3

puts "0.0001 has #{delta1.count} trades"

puts "sell on poloniex #{sell_on_poloniex}"

puts "sell on liqui = #{sell_on_liqui}"

puts "sell on quadrigacx = #{sell_on_quadrigacx}"
