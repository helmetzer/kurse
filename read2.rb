#!/usr/bin/ruby -w

##  # require_relative 'portfolio' # .rb is not needed
require_relative 'kurse'
$stdout = IO.new(1, mode: 'w:ASCII-8BIT')
 
kurse = Kurse.new
# puts kurse.inspect
exit
__END__
