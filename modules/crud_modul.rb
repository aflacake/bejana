module Bejana
  module CrudModul
    def tambah(kunci, nilai)
      if @data.has_key?(kunci.to_sym)
        puts "Kunci #{kunci} sudah ada. Gunakan perbarui untuk mengubah nilai."
      else
        @data[kunci.to_sym] = convert_nilai(nilai)
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
        @data[kunci.to_sym] = convert_nilai(nilai)
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

    private

    def convert_nilai(nilai)
      if nilai.match?(/^\d+$/)
        nilai.to_i
      else
        nilai
      end
    end
  end
end
