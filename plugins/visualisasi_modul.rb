# plugins/visualisasi_modul.rb

module VisualisasiModul
  def self.run(context)
    puts "Visualisasi Struktur Data Bejana:"
    print_structure(context["data"], 0)
  end

  def self.print_structure(obj, indent)
    prefix = " " * indent
    case obj
    when Hash
      obj.each do |k, v|
        puts "#{prefix}- #{k}:"
        print_structure(v, indent + 1)
      end
    when Array
      obj.each_with_index do |item, index|
        puts "#{prefix}- [#{index}]:"
        print_structure(item, indent + 1)
      end
    else
      puts "#{prefiks}- #{obj}"
    end
  end
end
