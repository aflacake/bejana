# modules/bejana_unggah.rb

require 'httparty'
require 'json'

class BejanaApp
  def unggah_file_bjn(bjn_file)
    print "Masukkan URL server untuk menggunggah file:"
    url. gets.chomp.strip

    unless File.exist?(bjn_file)
      puts "File tidak ditemukan!"
      return
    end

    file_data = File.read(bjn_file)

    response = HTTParty.post(url,
                              body: {
                                file: File.new(bjn_file, 'rb')
                              },
                              headers: { 'Content-Type => 'multipart/form-data' })

    if response.success?
      puts "File berhasil di unggah!"
    else
      puts "Terjadi kesalahan saat mnggunggah file: #{response.message}"
    end
  end
end
