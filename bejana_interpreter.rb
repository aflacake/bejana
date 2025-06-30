# bejana_interpreter.rb

require 'json'
require_relative 'modules/navigator_modul'

class BejanaInterpreter
  def initialize
    @data = {}
    @in_block = false
    @block_lines = []
    @navigator = Bejana::NavigatorModul::Navigator.new(self)
  end

  def jalankan(baris)
    case baris
    when /^langkah (\w+)$/
      @in_block = true
      @step_name = $1
      @step_lines = []
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
      end
    when /^mulai_dari (\w+)$/
      @navigator.mulai_dari($1)
    else
      if @in_block
        @step_lines << baris
      else
        proses(baris)
      end
    end
  end
      

  private

  def proses(baris)
    case baris
    when /^isi (\w+)\s+"?(.*?)"?$/
      kunci, nilai = $1, $2
      @data[kunci.to_sym] = nilai.match(/^\d+$/) ? nilai.to_i : nilai
    when /^cetak "(.*?)"$/
      teks = $1.gsub(/{{(.*?)}}/) { @data[$1.strip.to_sym] }
      puts teks
    when /^lanjut ke (\w+)$/
      return $1.to_sym
    when /^simpan$/
      simpan_ke_file
    when /^muat$/
      muat_dari_file
    when /^ambil semua dengan (\w+)\s*(==|!=|>=|<=|>|<|)\s*(\d+)$/
      kunci, operator, nilai = $1.to_sym, $2, $3, nilai.to_i
      cocok = @data.select do |k, v|
        v = v.to_i if v.to_s =~ /^\d+$/
        v.send(operator, nilai) rescue false
      end
      puts "Hasil filter:"
      cocok.each { |k, v| puts "#{k}: #{v}" }
    else
      puts "Perintah tidak dikenali: #{baris}"
    end
  end

  def simpan_ke_file(nama_file = "bejana_data.json")
      File.write(nama_file, @data.to_json)
      puts "Data berhasil disimpan ke #{nama_file}"
  end

  def muat_dari_file(nama_file = "bejana_data.json")
    if File.exist?(nama_file)
       json_data = JSON.parse(File.read(nama_file))
       @data = json_data.transform_keys(&:to_sym)
       puts "Data berhasil dimuat dari #{nama_file}"
    else
      puts "File #{nama_file} tidak ditemukan"
    end
  end
end
