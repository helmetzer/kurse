module Home
  HOME = '/daten/Users/Horst/'
  DOCS = HOME + 'Dokumente/'
end

class String
  def german_to_f
    f = self
    f.gsub!('.', '')
    f.tr!(',', '.')
    puts f
    f.to_f
  end
end
