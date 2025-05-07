# main.rb

require 'yaml'

require_relative 'core'

require_relative 'core'
require_relative 'modules/output'
require_relative 'modules/logika'
require_relative 'modules/input'
require_relative 'modules/selain_jika'
require_relative 'modules/selama'
require_relative 'modules/berhenti_jika'
require_relative 'modules/environment_modul'
require_relative 'modules/basis_data' #database
require_relative 'modules/penyimapanan_file'

class BejanaApp < Bejana::Wadah
  include Bejana::FungsiOutput
  include Bejana::FungsiLogika
  include Bejana::FungsiInput
  include Bejana::FungsiLogika::SelainJika
  include Bejana::FungsiLogika::Selama
  include Bejana::FungsiLogika::BerhentiJika

 attr_reader :env
end

files = Dir.glob("*.bjn") + Dir.glob("*.gnuc")

if files.empty?
  puts"Tidak ada file .bjn atau .gnuc ditemukan"
  exit
elsif files.size == 1
  bjn_file = files.first
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
  exit
end

Dir["./plugins/*.rb"].each { |file| require file }

if File.exists?('config.yaml')
  config = YAML.load_file('config.yaml')

  if config["plugins"]
    config["plugins"].each do |plugin_name|
      require_relative "./plugins/#{plugin_name}"
      plugin_module = Object.const_get(plugin_name.split('_').map(&:capitalize).join)
      plugin_module.run(context) if context
    end
  end
end
