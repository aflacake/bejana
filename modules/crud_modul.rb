# modules/crud_modul.rb

require 'json'

module Bejana
  module FungsiCRUD
    def catat_perubahan(kunci, lama, baru)
      perubahan = {
        waktu: Time.now,
        kunci: kunci,
        sebelum: lama,
        sesudah: baru,
      }
      File.open("riwayat_perubahan.json", "a") { |f| f.puts perubahan.to_json }
    end

    def tambah(kunci, nilai)
      kunci_sym = kunci.to_sym
      if @data.has_key?(kunci_sym)
        puts "Kunci #{kunci} sudah ada. Gunakan perbarui untuk mengubah nilai."
      else
        nilai_diparsing = nilai.match(/^\d+$/) ? nilai.to_i : nilai
        @data[kunci_sym] = nilai_diparsing
        catat_perubahan(kunci, nil, nilai_diparsing)
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
      kunci_sym = kunci.to_sym
      if @data.has_key?(kunci_sym)
        lama = @data[kunci_sym]
        nilai_diparsing = nilai.match(/^\d+$/) ? nilai.to_i : nilai
        @data[kunci_sym] = nilai_diparsing
        catat_perubahan(kunci, lama, nilai_diparsing)
        puts "Data '#{kunci}' berhasil diperbarui dengan nilai '#{nilai}'"
      else
        puts "Data dengan kunci '#{kunci}' tidak ditemukan."
      end
    end

    def hapus(kunci)
      kunci_sym = kunci.to_sym
      if @data.has_key?(kunci_sym)
        lama = @data[kunci_sym]
        @data.delete(kunci_sym)
        catat_perubahan(kunci, lama, nil)
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
  end
end

