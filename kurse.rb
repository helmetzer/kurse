require_relative 'Home'
require_relative 'mycsv'

class Kurse
  
  def initialize()
    @table = Hash.new()
  end

  def loadfile(filename = nil)
    filename ||= Home::DOCS + "Alles.csv"

    arr = Mycsv::loadfile(filename)
    arr.each do |row|
#   puts row.inspect
      isin = row[1]
      isin.kind_of? String and isin.length == 12 or next # not an ISIN
      curr = row[13]
      if curr != 'EUR'
        warn "unknown currency for ISIN #{isin} : #{curr}"
        next
      end
      total = row[12].german_to_f
      num = row[3].german_to_f
      @table[isin] = [total/num, row[2]]
    end
#   puts @table.inspect
  end

  def namevon(isin)
    @table[isin][1]
  end
  
  def kursvon(isin)
    @table[isin][0]
  end
  
end
__END__

kurse = Kurse.new()
kurse.loadfile()
puts kurse.inspect
