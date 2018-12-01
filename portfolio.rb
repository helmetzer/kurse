class Portfolio
  AssetClass = ["foo", "bar"]

  @@short = nil
  @@long = nil

  def initialize
    @@short ||= AssetClass
  end

  def get
    puts @@short.inspect, "in get"
    @@short
  end

end
