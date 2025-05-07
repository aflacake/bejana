# modules/basis_data.rb

class BasisData
  def initialize
    @data = []
  end

  def tambah(rekam)
    @data << rekam
  end

  def cari(kriteria)
    @data.select do |rekam|
      kriteria.all? { |key, value| rekam[key] == value }
    end
  end

  def semua
    @data
  end
end
