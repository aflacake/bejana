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
require_relative 'modules/manajemen_versi'

module Bejana
  class Wadah
    include Bejana::FungsiInput
    include Bejana::FungsiOutput
    include Bejana::FungsiLogika
    include Bejana::FungsiLogika::SelainJika
    include Bejana::FungsiLogika::Selama
    include Bejana::FungsiLogika::BerhentiJika
    include Bejana::FungsiCRUD
    include Bejana::ManajemenVersi

    attr_reader :env, :data

    def initialize(&block)
      @env = Bejana::EnvironmentModul::Environment.new
      @data = {}
      inisialisasi_versi
      simpan_versi(@data)
      instance_eval(&block) if block_given?
    end

    def isi(kunci, nilai)
      @data[kunci.to_sym] = nilai
      @env.set(kunci, nilai)
      simpan_versi(@data)
    end

    def urungkan_perubahan
      hasil = undo
      if hasil
        @data = hasil
        @env.clear
        @data.each { |k, v| @env.set(k, v) }
        puts "Undo berhasil."
      else
        puts "Tidak ada versi sebelumnya untuk undo."
      end
    end

    def ulangi_perubahan
      hasil = redo
      if hasil
        @data = hasil
        @env.clear
        @data.each { |k, v| @env.set(k, v) }
        puts "Redo berhasil."
      else
        puts "Tidak ada versi berikutnya untuk redo."
      end
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

    def muat_dari_cadangkan(nama_file)
      path = File.join("cadangkan", nama_file)
      if File.exist?(path)
        json_data = JSON.parse(File.read(path))
        @data = json_data.transform_keys(&:to_sym)
        puts "Data berhasil dimuat dari cadangkan #{nama_file}"
        @logger.info("Data dimuat dari cadangkan: #{nama_file}")
      else
        puts "Cadangkan #{nama_file} tidak ditemukan"
      end
    end
  end
end
