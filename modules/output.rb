# modules/output.rb

module Bejana
  module FungsiOutput
    def cetak(teks)
      puts teks.gsub(/{{(.*?)}}/) { |m| @env.get($1.strip.to_sym).to_s }
    end
  end
end
