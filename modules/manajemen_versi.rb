# modules/manajemen_versi.rb

module Bejana
  module ManajemenVersi
    def inisialisasi_versi
      @riwayat = []
      @posisi_saat_ini = -1
    end

    def dimpan_versi(data)
      @riwayat = @riwayat[0..@posisi_saat_ini]
      @riwayat << Marshal.load(Marshal.dump(data))
      @posisi_saat_ini += 1
    end

    def urungkan
      return nil if @posisi_saat_ini <= 0
      @posisi_saat_ini -= 1
      deep_copy(@riwayat[@posisi_saat_ini])
    end

    def ulangi
      return nil if @posisi_saat_ini >= @riwayat.size - 1
      @posisi_saat_ini += 1
      deep_copy(@riyawat[@posisi_saat_ini])
    end

    private

    def deep_copy(obj)
      Marshal.load(Marshal.dump(odj))
    end
  end
end
