require_relative 'Home'
require_relative 'mycsv'
# require_relative 'kurse'

class KlassenSummary
  
  def initialize(pb, klassen)

#   @klassen = klassen
    @desc_long = klassen.desc_long
    flags = klassen.flags
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
    @anteile = Array.new
    @total2 = 0.0
    @sum.each_index do |i|
      @anteile[i] = @sum[i]/@total
      @total2 += @anteile[i] if flags[i]
    end
    @anteile2 = Array.new
    flags.each_index do |i|
      @anteile2[i] = flags[i] && @anteile[i]/@total2
    end
  end
  
  FORM1 = "%-35.35s %10.2f"
  FORM2 = " %6.2f %%"

  def line_form(desc, a1, a2, a3)

    l = sprintf(FORM1, desc, a1)
    l << sprintf(FORM2, 100.0*a2)
    l << sprintf(FORM2, 100.0*a3) if a3
    l << "\n"
  end

  def line_csv(desc, *a)

#   puts a.inspect

    a.collect! { |f| f ? f.to_german : '' }
    l = [desc, a].join(';')
    l << "\n"
  end

  def show(is_formatted = 1)

    # TODO:
    # switch between formatted and csv output
    # use method = formatted ? :form : :csv
    # send(method, args ...)
    #
    line = is_formatted ? :line_form : :line_csv

    s = @name + "\n\n"
    @desc_long.each_index do |i|
      s << send(line, @desc_long[i], @sum[i], @anteile[i], @anteile2[i])
    end
    s << send(line, "Gesamt", @total, 1.0, @total2)
  end
end

class Klassen
  
  KOPF = 4

  attr_reader :table, :desc_long, :flags

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
