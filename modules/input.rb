# input.rb

module Bejana
  module FungsiInput
    def isi_dari_pengguna(kunci, prompt)
      print "#{prompt}: "
      input = gets.chomp
      input = input.to_i if input.match?(/^\d+$/)
      isi(kunci, input)
    end
  end
end