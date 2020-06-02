require 'csv'
# preso qui: https://stackoverflow.com/questions/1415819/find-type-of-the-content-number-date-time-string-etc-inside-a-string

CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end

body = "col1,col2,colonna3\nq,r,42\n1,TRUE,3.14\nTrue,true,4€,5$"
csv = CSV.new(body, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
csv_hash = csv.to_a.map {|row| row.to_hash }

puts "\n2. CSV option"
csv_hash.each do |row|
  puts row
  puts row.map{ |k,v|  v.class }.join(",")
end