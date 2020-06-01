require 'csv'

CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end

body = "col1,col2\nq,r\n1,2"
csv = CSV.new(body, :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])
csv_hash = csv.to_a.map {|row| row.to_hash }

csv_hash.each do |row|
  puts row
  puts row.map{ |k,v|  v.class }.join(",")
end