require_relative 'Home'
require_relative 'mycsv'
require_relative 'kurse'
require_relative 'klassen'

class PortfolioBewertet
  
  attr_reader :name, :table, :total

  def initialize(portfolio, kurse)
    @table = Hash.new()
    @name = portfolio.name
    @total = 0.0

    tab = portfolio.table

#   puts tab.inspect
    tab.each_key do |isin|
      k = kurse.kursvon(isin)
      n = kurse.namevon(isin)
      stuecke = tab[isin]
      kt = k*stuecke
      @table[isin] = [n, stuecke, k, kt]
      @total += kt
    end
  end
  
  def wertvon(isin)
    @table[isin][3]
  end

  def bezeichnungvon(isin)
    @table[isin][0]
  end

  def show

    s = @name + "\n\n"
    @table.each_key do |isin|
      s << sprintf("%s %-35.35s %10.3f %8.2f %10.2f\n", isin, *@table[isin])
    end
    s << sprintf("%79.2f\n", @total)
  end
end

class Portfolio
  
  attr_reader :name, :table

  def initialize()
    @table = Hash.new(0.0)
    @name = nil
  end

  def loadfile(filename = nil)
    filename ||= Home::BUCKS + "Depot.csv"

    arr = Mycsv::loadfile(filename)
#   puts(filename)
    arr.each do |row|
#     puts row.inspect
      isin = row[0]
      if isin == "Depotnummer"
        @name ||= "Depotnummer: #{row[1]}"
        next
      end
      if isin == "File"
        newfile = row[1]
        newfile = Home::BUCKS + newfile if newfile[0] != '/'
        self.loadfile(newfile)
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
portfolio.loadfile(Home::BUCKS + "test.csv")
# puts portfolio.inspect

pb = PortfolioBewertet.new(portfolio, kurse)
print pb.show

klasse = Klassen.new
klasse.loadfile

sum = KlassenSummary.new(pb, klasse)
print sum.show
__END__
      if curr != 'EUR'
        warn "unknown currency for ISIN #{isin} : #{curr}"
        next
      end
