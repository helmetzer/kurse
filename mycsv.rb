require 'csv'

module Mycsv
  
  def loadfile(filename)

    arr = Array.new()
    File.open(filename, encoding: 'iso-8859-1') do |file|
      arr = file.readlines
    end

    arrout = Array.new()
    arr.each do |line|
      line2 = line.encode('UTF-8')
#     CSV.parse(line2, {:col_sep => ';'}) do |row|
      arrout.push(CSV.parse(line2, {:col_sep => ';'}))
    end
    return arrout
  end # loadfile
  
end
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
