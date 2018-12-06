module Home
  HOME = '/daten/Users/Horst/'
  DOCS = HOME + 'Dokumente/'
  BUCKS = DOCS + 'Bucks/'
end

class String
  def german_to_f
    f = self
    f.gsub!('.', '')
    f.tr!(',', '.')
    f.to_f
  end
end
