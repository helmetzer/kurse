#!/usr/bin/ruby -w

require_relative 'Home'
require_relative 'kurse'
require_relative 'portfolio'
require_relative 'kurse'
 
# usage is: andep.rb [ -csv ] [ file ]

formatted = ARGV[0] != '-csv' or ARGV.shift
file = ARGV[0] || Home::BUCKS + "test.csv"

kurse = Kurse.new()
kurse.loadfile()

portfolio = Portfolio.new()
portfolio.loadfile(file)

pb = PortfolioBewertet.new(portfolio, kurse)
print pb.show

klasse = Klassen.new
klasse.loadfile

sum = KlassenSummary.new(pb, klasse)
print sum.show(formatted)
exit
__END__
