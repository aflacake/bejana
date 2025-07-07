# core.rb

require 'json'
require 'fileutils'

require_relative 'modules/input'
require_relative 'modules/output'
require_relative 'modules/logika'
require_relative 'modules/selain_jika'
require_relative 'modules/berhenti_jika'
require_relative 'modules/environment_modul'
require_relative 'modules/crud_modul'

module Bejana
  class Wadah
    include Bejana::FungsiInput
    include Bejana::FungsiOutput
    include Bejana::FungsiLogika
    include Bejana::FungsiLogika::SelainJika
    include Bejana::FungsiLogika::Selama
    include Bejana::FungsiLogika::BerhentiJika
    include Bejana::FungsiCRUD

    attr_reader :env, :data

    def initialize(&block)
      @env = Bejana::EnvironmentModul::Environment.new
      @data = {}
      instance_eval(&block) if block_given?
    end

    def isi(kunci, nilai)
      @data[kunci.to_sym] = nilai
      @env.set(kunci, nilai)
    end

    def ambil(kunci)
      @data[kunci.to_sym] || @env.get(kunci)
    end

    def tampilkan_semua
      @data.each { |k, v| puts "#{k} => #{v}" }
    end

    def simpan
      if File.exist?("bejana_data.json")
        timestamp = Time.now.sfrftime("%Y%m%d_%H%M%S")
        FileUtils.cp("bejana_data.json", "cadangkan/bejana_data_#{timestamp}.json")
      end

      File.write("bejana_data.json", @data.to_json)
      puts "Data berhasil disimpan ke bejana_data.json"
    end

    def method_missing(nama_metode, *argumen, &blok)
      if argumen.length == 1
        isi(nama_metode, argumen.first)
      elsif argumen.empty?
        ambil(nama_metode)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      true
    end
  end
end
