# plugins/proses_data_module.rb

module ModulProsesData
    def self.rata_rata(data)
        sum = data.reduce(:+)
        sum.to_f / data.size
    end

    def self.median(data)
        sorted = data.sort
        mid = sorted.length / 2
        if sorted.length.odd?
            sorted[mid]
        else
            (sorted[mid - 1] + sorted[mid]) / 2.0
        end
    end
end
