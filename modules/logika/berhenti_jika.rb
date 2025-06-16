# modules/logika/berhenti_jika.rb

module Bejana
  module FungsiLogika
    module BerhentiJika
      def berhenti_jika(kunci, &kondisi)
        if kondisi.call(@data[kunci.to_sym])
          throw :berhenti
        end
      end
    end
  end
end
