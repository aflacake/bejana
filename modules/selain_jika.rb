# selain_jika.rb

module Bejana
  module FungsiLogika
    module SelainJika
      def selain_jika(kunci, kondisi, &block)
        @else_block = blok
      end

      def jika(kunci, kondisi)
        nilai = @data[kunci.to_sym]
        if kondisi.call(nilai)
          yield(nil) if block_given?
        else
          if block_given? && @else_block
            instance_exec(&@else_block)
          end
        end
      end
    end
  end
end