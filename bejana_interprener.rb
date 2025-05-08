# bejana_interprener.rb

require_relative 'modules/navigator_modul'

@navigator = Bejana::NavigatorModul::Navigator.new(self)

class BejanaInterprener
  def initialize
    @data = {}
    @in_block = false
    @block_lines = []
  end

  def jalankan(baris)
    case baris
    when /^langkah (\w+)$/
      @in_block = true
      @step_name = $1
      @step_lines = []
    when /^selesai$/
      if @in_step
        lines = @step_lines.dup
        @navigator.tambah(@step_name) do
          lines.each do |1|
            hasil = proses(1)
            return hasil if hasil.is_a?(Symbol)
          end
          nil
        end
        @in_step = false
      end
    when /^mulai_dari (\w+)$/
      @navigator.mulai_dari($1)
    else
      if @in_step
        @step lines << baris
      else
        proses(baris)
      end
    end
  end
      

  private

  def proses(baris)
    case baris
    when /^isi (\w+)\s+"?(.*?)"?$/
      kunci, nilai = $1, $2
      @data[kunci.to_sym] = nilai.match(/^\d+$/) ? nilai.to_i : nilai
    when /^cetak "(.*?)"$/
      teks = $1.gsub(/{{(.*?)}}/) { @data[$1.strip.to_sym] }
      puts teks
    when /^lanjut ke (\w+)$/
      return $1.to_sym
    else
      puts "Perintah tidak dikenali: #{baris}"
    end
  end
end
