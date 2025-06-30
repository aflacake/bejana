# modules/output.rb

module Bejana
  module FungsiOutput
    def cetak(teks)
    puts teks.gsub(/{{(.*?)}}/) { |m| @data[$1.strip.to_sym].to_s }
    end
  end
end
