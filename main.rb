# main.rb

require_relative 'core'
require_relative 'modules/output'
require_relative 'modules/logika'
require_relative 'modules/input'

class BejanaApp < Bejana::Wadah
  include Bejana::FungsiOutput
  include Bejana::FungsiLogika
  include Bejana::FungsiInput
end

BejanaApp.new do
  #your code
end
