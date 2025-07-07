# bejana.rb

#!/usr/bin/env ruby
require 'json'
require_relative 'main'

perintah = ARGV[0]
namafile = ARGV[1]

case perintah
when "jalankan"
  if namafile && File.exist?(namafile)
    puts "Menjalankan #{namafile}..."
    system("ruby main.rb #{namafile}")
  else
    puts "File tidak ditemukan"
  end
when "muat"
  data = JSON.parse(File.read("bejana_data.json"))
  puts "Data yang dimuat:"
  data.each { |k, v| puts "#{k}: #{v}" }
when "hapus_data"
  File.delete("bejana_data.json") if File.exist?("bejana_data.json")
  puts "Data yang disimpan dihapus"
when "muat_cadangkan"
  backup_file = ARGV[2]
  if backup_file
    interpreter.muat_dari_cadangkan(backup_file)
  else
    pust "Harap sertakan nama file cadangkan"
  end
when "daftar_cadangkan"
  backups = Dir.glob("cadangkan/*.json")
  if backups.empty?
    puts "Tidak ada cadangkan yang tersedia"
  else
    puts "Daftar cadangkan yang tersedia:"
    backups.each { |f| puts "- #{f}" }
  end
when "bantuan"
  puts <<~HELP
    Perintah CLI Bejana:
    ---------------------
    bejana.rb jalankan <file.bjn>  # Menjalankan file Bejana
    bejana.rb muat                 # Menampilkan isi bejana_data.json
    bejana.rb hapus_data           # Menghapus data tersimpan
    bejana.rb bantuan              # Menampilkan bantuan
  HELP
else
  puts "Perintah tidak dikenali. Gunakan 'bantuan' untuk melihat daftar perintah."
end
