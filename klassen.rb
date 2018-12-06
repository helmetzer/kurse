require_relative 'Home'
require_relative 'mycsv'
# require_relative 'kurse'

class KlassenSummary
  
  def initialize(pb, klassen)

#   @klassen = klassen
    @desc_long = klassen.desc_long
    l = @desc_long.size
    @sum = Array.new(l, 0.0)
    @name = pb.name
    @total = pb.total

    tab = pb.table

#   puts tab.inspect
    tab.each_key do |isin|
      wert = pb.wertvon(isin)
      gewichte = klassen.table[isin]
      if gewichte
        www = gewichte.collect {|w| w*wert }
        @sum.collect! {|s| s + www.shift }
      else
        warn "Keine Gewichtung fuer ISIN #{isin} : #{pb.bezeichnungvon(isin)}"

        @sum[-1] += wert # zu Sonstiges addieren
      end
    end
    @anteile = @sum.collect {|s| s/@total}
  end
  
  def show

    form = "%-35.35s %10.2f  %10.2f %%\n"
    s = @name + "\n\n"
    @desc_long.each_index do |i|
      s << sprintf(form, @desc_long[i], @sum[i], 100.0*@anteile[i])
    end
    s << sprintf(form, "Gesamt", @total, 100.0)
  end
end

class Klassen
  
  KOPF = 4

  attr_reader :table, :desc_long

  def initialize()
    @table = Hash.new()
#   @name = nil
  end

  def loadfile(filename = nil)
    filename ||= Home::BUCKS + "WP-Daten.csv"

    arr = Mycsv::loadfile(filename)
    @desc = arr.shift
    @desc.slice!(0, KOPF)
    @desc_long = arr.shift
    @desc_long.slice!(0, KOPF)
    @flags = arr.shift
    @flags.slice!(0, KOPF)
    arr.each do |row|
#     puts row.inspect
      isin = row[0]
      isin.kind_of? String and isin.length == 12 or next # not an ISIN
      rest = row[KOPF .. -1]
      rest.collect! {|s| s ? s.german_to_f : 0.0}
      @table[isin] = rest
    end
#   puts @table.inspect
  end
  
end
__END__
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
