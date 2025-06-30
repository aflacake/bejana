# modules/selama.rb

module Bejana
  module FungsLogika
    module Selama
      def selama(kondisi)
        while kondisi.call
          yield
        end
      end
    end
  end
end
