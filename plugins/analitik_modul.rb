#  plugins/analitik_modul.rb

module ModuleAnalitik
    def self.deviasi_standar(data)
        mean = data.reduce(:+) / data.size.to_f
        variance = data.reduce(0) { |sum, val| sum + (val - mean)**2 } / data.size
    end
end
