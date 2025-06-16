# jalankan_bejana.rb

require_relative 'bejana_interprener'
interprener = BejanaInterprener.new

# Baca dari file
filename = ARGV[0] || 'script.bj'

if File.exist?(filename)
  File.readlines(filename).each_with_index do |baris, i|
    baris.strip!
    next if baris.empty? || baris.start_with?('#')
    begin
      interprener.jalankan(baris)
    rescue => e
      puts "Error di baris #{i + 1}: #{baris}"
      puts "Pesan: #{e.message}"
    end
  end
else
  puts "File #{filename} tidak ditemukan"
end
