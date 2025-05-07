# modules/penyimpanan_file.rb
require 'json'

class PenyimpananFile
  def initialize(nama_file)
    @nama_file = nama_file
  end

  def simpan(data)
    File.open(@nama_file, 'w') do |file|
      file.write(data.to_json)
    end
  end

  def muat
    if File.exist?(@nama_file)
      JSON.parse(File.read(@nama_file), symbolize_names: true)
    else
      []
    end
  end
end
