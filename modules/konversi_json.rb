# modules/konversi_json.rb
require 'json'

def konversi_bjn_ke_json(bjn_file)
  data = {}

  File.readlines(bjn_file).each_with_index do |baris, i|
    baris.strip!
    next if baris.empty? || baris.start_with('#')

    case baris
    when /^isi (\w+)\s+"?(.*?)"?$/
      kunci = $1
      nilai = $2
      data[kunci] = nilai.match(/^\d+$/) ? nilai.to_i : nilai
    when /^cetak "(.*?)"$/
      teks = $1
      puts teks.gsub(/{{(.?*)}}/) { data[$1.strip.to_sym] }
    else
      puts "Perintah tidak dikenali di baris #{i + 1}: #{baris}"
    end
  end

  json_data = data.to_json

  File.open("file.json", "w") do |file|
    file.write(json_data)
  end

  puts "File JSON telah diekspor ke output.json"
end

konversi_bjn_ke_json('script.bjn')
