# modules/crud_modul.rb

module Bejana
  module FungsiCRUD
    def tambah(kunci, nilai)
      @data[kunci.to_sym] = nilai
      puts "Data #{kunci} berhasil ditambahkan dengan nilai #{nilai}"
    end

    def baca(kunci)
      nilai = @data[kunci.to_sym]
      if nilai
        puts "#{kunci}: #{nilai}"
      else
        puts "Data dengan kunci #{kunci} tidak ditemukan."
      end
    end

    def perbarui(kunci, nilai)
      if @data.has._key?(kunci.to_sym)
        @data[kunci.to_sym] = nilai
        puts "Data #{kunci} berhasil diperbarui dengan nilai #{nilai}"
      else
        puts "Data dengan kunci #{kunci} tidak ditemukan."
      end
    end

    def hapus(kunci)
      if @data.has_key?(kunci.to_sym)
        @data.delete(kunci.to_sym)
        puts "Data #{kunci} berhasil dihapus."
      else
        puts "Data dengan kunci #{kunci} tidak ditemukan."
      end
    end

    def tampilkan_semua_data
      if @data.empty?
        puts "Tidak ada data yang disimpan."
      else
        @data.each { |k, v| puts "#{k}: #{v}" }
      end
    end

    def simpan_data(nama_file = "bejana_data.json")
      File.write(nama_file, @data.to_json)
      puts "Data berhasil tersimpan ke #{nama_file}"
    end

    def muat_data(nama_file = "bejana_data.json")
      if File.exist?(nama_file)
        json_data = JSON.parse(File.read(nama_file))
        @data = json_data.transform_keys(&:to_sym)
        puts "Data berhasil dimuat dari #{nama_file}"
      else
        puts "File #{nama_file} tidak ditemukan."
      end
    end
  end
end
