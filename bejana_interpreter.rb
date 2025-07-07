#bejana_interpreter.rb

require 'json'
require 'logger'
require 'yaml'

require_relative 'modules/navigator_modul'
require_relative 'modules/crud_modul'

class BejanaInterpreter
  include Bejana::FungsiCRUD

  def initialize(mode_pelacakan: false)
    config = YAML.load_file('config.yaml') rescue {}
    @simpan_otomatis = config["simpan_otomatis"] != false

    @data = {}
    @in_block = false
    @block_lines = []
    @navigator = Bejana::NavigatorModul::Navigator.new(self)
    @logger = Logger.new("bejana.log", "daily")
    if mode_pelacakan
      @logger.level = Logger::DEBUG
      puts "Mode pelacakan diaktifkan."
    else
      @logger.level = Logger::INFO
    end
  end

  def jalankan(baris)
    return if baris.strip.start_with?('#')
    @logger.debug("Memulai eksekusi: #{baris}")

    simpan_ke_file if @simpan otomatis

    case baris
    when /^langkah (\w+)$/
      @in_block = true
      @step_name = $1
      @step_lines = []
      @logger.info("Langkah '#{@step_name}' dimulai.")
    when /^selesai$/
      if @in_block
        lines = @step_lines.dup
        @navigator.tambah(@step_name) do
          lines.each do |line|
            hasil = proses(line)
            return hasil if hasil.is_a?(Symbol)
          end
          nil
        end
        @in_block = false
        @logger.info("Langkah '#{@step_name}' selesai.")
      end
    when /^mulai_dari (\w+)$/
      @navigator.mulai_dari($1)
      @logger.info("Mulai dari langkah '#{$1}'.")
    else
      if @in_block
        @step_lines << baris
        @logger.debug("Menambahkan baris ke langkah: #{baris}")
      else
        proses(baris)
      end
    end
  rescue => e
    @logger.error("Terjadi kesalahan pada perintah '#{baris}': #{e.message}")
    raise e
  end

  def cari_data_pola(pola)
    hasil = @data.select { |k, v| v.to_s.match(/#{pola}/) }
    puts "Hasil pencarian pola '#{pola}':"
    hasil.each { |k, v| puts "#{k}: #{v}" }
    @logger.info("Pencarian pola: #{pola} => #{hasil.inspect}")
  end

  def sortir_data(kunci, urutan = "asc")
    cocok = @data.sort_by { |k ,v| v.to_s }
    cocok = urutan == "desc" ? cocok.reverse : cocok
    puts "Data setelah diurutkan:"
    cocok.each { |k, v| puts "#{k}: #{v}" }
    @logger.info("Data diurutkan berdasarkan #{kunci} #{urutan}")
  end

  private

  def proses(baris)
    @logger.debug("Memproses perintah: #{baris}")

    case baris
    when /^tambah (\w+)\s+"?(.*?)"?$/
      tambah($1, $2)
      @logger.info("Menambah data: #{$1} => #{$2}")
    when /^baca (\w+)$/
      hasil = baca($1)
      @logger.info("Membaca data: #{$1} => #{hasil.inspect}")
      hasil
    when /^perbarui (\w+)\s+"?(.*?)"?$/
      perbarui($1, $2)
      @logger.info("Memperbarui data: #{$1} => #{$2}")
    when /^hapus (\w+)$/
      hapus($1)
      @logger.info("Menghapus data: #{$1}")
    when /^tampilkan_semua_data$/
      tampilkan_semua_data
      @logger.info("Menampilkan semua data.")
    when /^isi (\w+)\s+"?(.*?)"?$/
      kunci, nilai = $1, $2

      nilai_parsed = case nilai
                     when /^\d+$/ then nilai.to_i
                     when /^(true|false)$/i then nilai.downcase == "true"
                     else nilai
                     end

      @data[kunci.to_sym] = nilai_parsed
      @logger.info("Set variabel: #{kunci} => #{@data[kunci.to_sym].inspect}")
    when /^cetak "(.*?)"$/
      teks = $1.gsub(/{{(.*?)}}/) { @data[$1.strip.to_sym] }
      puts teks
      @logger.info("Cetak: #{teks}")
    when /^lanjut ke (\w+)$/
      @logger.info("Lanjut ke langkah: #{$1}")
      return $1.to_sym
    when /^simpan$/
      simpan_ke_file
    when /^muat$/
      muat_dari_file
    when /^ambil semua dengan (\w+)\s*(==|!=|>=|<=|>|<|)\s*(\d+)$/
      kunci, operator, nilai = $1.to_sym, $2, $3.to_i
      filter_data(kunci, operator, nilai)
    when /^cari "(.*?)"$/
      pola = $1
      cari_data_pola(pola)
    when /^sortir_data (\w+)(?: (asc|desc))?$/
      kunci = $1
      urutan = $2 || "asc"
      sortir_data(kunci, urutan)
    else
      @logger.warn("Perintah tidak dikenali: #{baris}")
      puts "Perintah tidak dikenali: #{baris}"
    end
  end

  def simpan_ke_file(nama_file = "bejana_data.json")
    File.write(nama_file, @data.to_json)
    puts "Data berhasil disimpan ke #{nama_file}"
    @logger.info("Data disimpan ke file: #{nama_file}")
  end

  def muat_dari_file(nama_file = "bejana_data.json")
    if File.exist?(nama_file)
      json_data = JSON.parse(File.read(nama_file))
      @data = json_data.transform_keys(&:to_sym)
      puts "Data berhasil dimuat dari #{nama_file}"
      @logger.info("Data dimuat dari file: #{nama_file}")
    else
      puts "File #{nama_file} tidak ditemukan"
      @logger.warn("Gagal muat data, file tidak ditemukan: #{nama_file}")
    end
  end

  def filter_data(kunci, operator, nilai, kondisi = nil)
    cocok = @data.select do |k, v|
    v_num = case v
            when TrueClass, FalseClass then v ? 1 : 0
            when String then v.to_i rescue v
            else v.to_s =~ /^\d+$/ ? v.to_i : v
            end
      case operator
      when '==' then v_num == nilai
      when '!=' then v_num != nilai
      when '>'  then v_num > nilai
      when '<'  then v_num < nilai
      when '>=' then v_num >= nilai
      when '<=' then v_num <= nilai
      else false
      end
    end

    if kondisi
      cocok = cocok.select { |k, v| v.to_s.include?(kondisi) }
    end

    puts "Hasil filter:"
    cocok.each { |k, v| puts "#{k}: #{v}" }
    @logger.info("Filter data: #{kunci} #{operator} #{nilai} => #{cocok.inspect}")
  end
