# core.rb

require_relative 'modules/input'
require_relative 'modules/output'
require_relative 'modules/logika'
require_relative 'modules/selain_jika'
require_relative 'modules/berhenti_jika'
require_relative 'modules/environment_modul'

module Bejana
  class Wadah
    include Bejana::FungsiInput
    include Bejana::FungsiOutput
    include Bejana::FungsiLogika
    include Bejana::FungsiLogika::SelainJika
    include Bejana::FungsiLogika::Selama
    include Bejana::FungsiLogika::BerhentiJika

    attr_reader :env

    def initialize(&block)
      @env = Bejana::EnvironmentModul::Environment.new
      instance_eval(&block) if block_given?
    end

    def isi(kunci, nilai)
      @env.set(kunci, nilai)
    end

    def ambil(kunci)
      @env.get(kunci)
    end

    def tampilkan_semua
      @env.all.each { |k, v| puts "#{k} => #{v}" }
    end
  end
end
