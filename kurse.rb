require 'csv'
require_relative 'Home'

class Kurse
  
  def initialize()
    @table = Hash.new()
  end

  def loadfile(filename = nil)
    filename ||= Home::DOCS + "Alles.csv"

    arr = Array.new()
    File.open(filename, encoding: 'iso-8859-1') do |file|
      arr = file.readlines
    end

    arr.map! {|line| line.encode('UTF-8')}
    arr.each do |line2|
      CSV.parse(line2, {:col_sep => ';'}) do |row|
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
    end
  end
  
end

kurse = Kurse.new()
kurse.loadfile()
puts kurse.inspect
__END__
# this works for LATIN1 encoded files
#     line.encode!("utf-8", "utf-8", :invalid => :replace)
# don't like Ruby encoding stuff
# so use external iconv 
    # convert filename to UTF-8:
    # iconv -f LATIN1 -t UTF-8 filename > out
      # hope single quote not in filename
      filename = "iconv -f LATIN1 -t UTF-8 '#{filename}'"
      s = %x/#{filename}/
#     puts s.inspect
      arr = s.split("\n")
#     puts arr.inspect
