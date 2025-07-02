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
    when /^tambah (\w+)\s+"?(.*?)"?$/
      tambah($1, $2)
    when /^baca (\w+)$/
      baca($1)
    when /^perbarui (\w+)\s+"?(.*?)"?$/
      perbarui($1, $2)
    when /^hapus (\w+)$/
      hapus($1)
    when /^tampilkan_semua_data$/
      tampilkan_semua_data
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
      kunci, operator, nilai = $1.to_sym, $2, $3.to_i
      cocok = @data.select do |k, v|
        v_num = v.to_s =~ /^\d+$/ ? v.to_i : v
        v_num.send(operator, nilai) rescue false
      end
      puts "Hasil filter:"
      cocok.each { |k, v| puts "#{k}: #{v}" }
    else
      puts "Perintah tidak dikenali: #{baris}"
    end
  end

  def tambah(kunci, nilai)
    if @data.has_key?(kunci.to_sym)
      puts "Kunci #{kunci} sudah ada. Gunakan perbarui untuk mengubah nilai."
    else
      @data[kunci.to_sym] = nilai.match(/^\d+$/) ? nilai.to_i : nilai
      puts "Data '#{kunci}' berhasil ditambahkan dengan nilai '#{nilai}'"
    end
  end

  def baca(kunci)
    if @data.has_key?(kunci.to_sym)
      puts "#{kunci}: #{@data[kunci.to_sym]}"
    else
      puts "Data dengan kunci '#{kunci}' tidak ditemukan."
    end
  end

  def perbarui(kunci, nilai)
    if @data.has_key?(kunci.to_sym)
      @data[kunci.to_sym] = nilai.match(/^\d+$/) ? nilai.to_i : nilai
      puts "Data '#{kunci}' berhasil diperbarui dengan nilai '#{nilai}'"
    else
      puts "Data dengan kunci '#{kunci}' tidak ditemukan."
    end
  end

  def hapus(kunci)
    if @data.delete(kunci.to_sym)
      puts "Data '#{kunci}' berhasil dihapus."
    else
      puts "Data dengan kunci '#{kunci}' tidak ditemukan."
    end
  end

  def tampilkan_semua_data
    if @data.empty?
      puts "Tidak ada data yang disimpan."
    else
      puts "Isi data saat ini:"
      @data.each { |k, v| puts "#{k}: #{v}" }
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
