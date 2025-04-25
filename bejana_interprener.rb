# bejana_interprener.rb

class BejanaInterprener
  def initialize
    @data = {}
    @in_block = false
    @block_lines = []
  end

  def jalankan(baris)
    case baris
    when /^mulai$/
      @in_block = true
      @block_lines = []
    when /^selesai$/
      @in_block = false
      @block_lines.each { |line| jalankan(line) }
    else
      if @in_block
        @block_lines << baris
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
    else
      puts "Perintah tidak dikenali: #{baris}"
    end
  end
end
