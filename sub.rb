#!/usr/bin/ruby -w

def sub(x, a1, a2)
  x *= 3
  a1 += 5
  a2[0] = 4711
end

y = 2
a1 = [0, 1, 2]
a2 = [9, 8, 7]
sub(y, a1[1], a2)
puts y
puts a1.inspect
puts a2.inspect
__END__
