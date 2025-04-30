# main.rb

require_relative 'core'
require_relative 'modules/output'
require_relative 'modules/logika'
require_relative 'modules/input'
require_relative 'modules/selain_jika'
require_relative 'modules/selama'
require_relative 'modules/berhenti_jika'

class BejanaApp < Bejana::Wadah
  include Bejana::FungsiOutput
  include Bejana::FungsiLogika
  include Bejana::FungsiInput
  include Bejana::FungsiLogika::SelainJika
  include Bejana::FungsiLogika::Selama
  include Bejana::FungsiLogika::BerhentiJika
end

Dir["./plugins/*.rb"].each { |file| require file }

files = Dir.glob("*.bjn") + Dir.glob("*.gnuc")

if files.empty?
  puts"Tidak ada file .bjn atau .gnuc ditemukan"
  exit
elsif files.size == 1
  bjn_file = file.first
else
  puts "Pilih file.bjn yang ingin dijalankan"
  files.each.with_index { |f, i| puts"#{i + 1}.#{f}" }
  print ">"
  index = gets.chomp.to_i - 1
  bjn_file = files[index]
end

kode = File.read(bjn_file)

case File.extname(selected_file)
when ".bjn"
  BejanaApp.new { eval(code) }
when ".gnuc"
  puts "Menjalankan file.gnuc: #{selected_file}"
  puts "Konten file .gnuc:"
  puts kode
else
  puts"Ekstensi file tidak dikenali"
end
