# modules/logika/selain_jika.rb

module Bejana
  module FungsiLogika
    module SelainJika
      def selain_jika(&block)
        yield if @last_jika == false && block_given?
      end
    end
  end
end
