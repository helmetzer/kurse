require_relative 'Home'
require_relative 'mycsv'
require_relative 'kurse'

class PortfolioBewertet
  
  def initialize(portfolio, kurse)
    @table = Hash.new()
    @name = portfolio.name
    tab = portfolio.table

#   puts tab.inspect
    tab.each_key do |isin|
      k = kurse.kursvon(isin)
      n = kurse.namevon(isin)
      stuecke = tab[isin]
      @table[isin] = [n, stuecke, k, k*stuecke]
    end
  end
end

class Portfolio
  
  attr_reader :name, :table

  def initialize()
    @table = Hash.new(0.0)
    @name = "Anonymous depot"
  end

  def loadfile(filename = nil)
    filename ||= Home::DOCS + "Depot.csv"

    arr = Mycsv::loadfile(filename)
    arr.each do |row|
#     puts row.inspect
      isin = row[0]
      if isin == "Depotnummer"
        @name = row[1]
        next
      end
      isin.kind_of? String and isin.length == 12 or next # not an ISIN
      curr = row[2].german_to_f
      @table[isin] += curr
    end
#   puts @table.inspect
  end
  
end

kurse = Kurse.new()
kurse.loadfile()

portfolio = Portfolio.new()
portfolio.loadfile()
# puts portfolio.inspect
puts portfolio.name

pb = PortfolioBewertet.new(portfolio, kurse)
puts pb.inspect
__END__
      if curr != 'EUR'
        warn "unknown currency for ISIN #{isin} : #{curr}"
        next
      end
