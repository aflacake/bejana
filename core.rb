# core.rb

module Bejana
  class Wadah
    include Bejana::FungsiInput
    include Bejana::FungsiOutput
    include Bejana::FungsiLogika

    def initialize(&block)
      @data = {}
      instance_eval(&block) if block_given?
    end

    def isi(kunci, nilai)
      @data[kunci.to_sym] = nilai
    end

    def data
      @data
    end
  end
end
