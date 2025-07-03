# jalankan_bejana.rb

require_relative 'bejana_interpreter'
interpreter = BejanaInterpreter.new

# Baca dari file
filename = ARGV[0] || 'script.bj'

if File.exist?(filename)
  kode = File.read(filename)

  if kode.bytes[0, 3] == [0xEF, 0xBB, 0xBF]
    kode = kode[3..-1]
    puts "BOM ditemukan dan dihapus."
  end

  puts "Kode yang dibaca dari file #{filename}:"
  puts kode

  kode.each_line.with_index do |baris, i|
    baris.strip!
    next if baris.empty? || baris.start_with?('#')
    begin
      interpreter.jalankan(baris)
    rescue => e
      puts "Error di baris #{i + 1}: #{baris}"
      puts "Pesan: #{e.message}"
    end
  end
else
  puts "File #{filename} tidak ditemukan"
end
