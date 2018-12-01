#!/usr/bin/ruby -w

require 'csv'

##  # require_relative 'portfolio' # .rb is not needed
require_relative 'portfolio' # .rb is not needed

filename = "test.txt"
filename = "STDIN"
filename = $stdin
file = STDIN
file = ARGF

bla = Portfolio.new
puts bla.inspect
bb = bla.get
puts bb
bb[0] = "hugo"
bb = bla.get
puts bb

file.each_line do |line|
# line2 = line.gsub('&amp;', '&')
  line.encode!("utf-8", "utf-8", :invalid => :replace)
  CSV.parse(line, {:col_sep => ';'}) do |row|
    puts row.inspect
  end
end

__END__
IO.foreach(STDIN) { |line| puts line }
while line = gets
  puts line
end
# IO.open(filename) do |file|
  puts file.gets
  # so kann dann der Rest der Datei verarbeitet werden
# end
CSV(ARGF, {:col_sep => ';'}) do |csv_in|
  csv_in.each { |row| puts row.inspect }
end
