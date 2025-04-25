# logika.rb

module Bejana
  module FungsiLogika
    def initialize(&block)
      super(&block)
      @fungsi = {}
    end

    def fungsi(nama, *parameter, &blok)
      @fungsi[nama.to_sym] = { parameters: parameter, block: blok }
    end

    def panggil(nama, *args)
      if @fungsi[nama.to_sym]
        context = @fungsi[nama.to_sym]
        params = context[:parameters]
        blok = context[:block]

        instance_exec(*args, &blok)
      else
        puts "Fungsi '#{nama}' tidak ditemukan"
      end
    end

    def jika(kunci, kondisi)
      nilai = @data[kunci.to_sym]
      if kondisi.call(nilai)
        yield(nil) if block_given?
      end
    end
  end
end
