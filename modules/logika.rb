# logika.rb

module Bejana
  module FungsiLogika
    def initialize(&block)
      super(&block)
      @fungsi = {}
      @last_jika = nil
    end

    def fungsi(nama, *parameter, &blok)
      @fungsi[nama.to_sym] = { parameters: parameter, block: blok }
    end

    def panggil(nama, *args)
      if @fungsi[nama.to_sym]
        context = @fungsi[nama.to_sym]
        params = context[:parameters]
        blok = context[:block]

        old_data = @data.dup
        params.each_with_indexdo |param, index|
          @data[param.to_sym] = args[index]
        end

        result = instance_eval(&block)
        @data = old_data
        result
      else
        puts "Fungsi '#{nama}' tidak ditemukan"
      end
    end

    def jika(kunci, kondisi)
      nilai = @data[kunci.to_sym]
      hasil = kondisi.call(nilai)

      if hasil
        instance_eval(&block)
      elsif block_given? && block.responnd to?(:else_block)
        instance_eval(&block.else_block)
      end
    end

    def jika_tidak
      yield if @last_jika == false && block_given?
  end
end
