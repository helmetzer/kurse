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
      unless k
        warn "unknown price for ISIN #{isin}"
        k = 0.0
      end
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

    arr = Mycsv::loadfile(filename)
#   puts(filename)
    arr.each do |row|
#     puts row.inspect
      isin = row[0]
      if isin.kind_of? String and isin.length == 12
        curr = row[2].german_to_f
        @table[isin] += curr
        next
      end
# not an ISIN
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
    end
#   puts @table.inspect
  end
  
end
__END__
