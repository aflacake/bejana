# bejana_api.rb

require 'sinatra'
require 'json'

require_relative 'bejana_interpreter'

interpreter = BejanaInterpreter.new

set :port, 4567
set :bind, '0.0.0.0'

VALID_COMMANDS = [
  /^tambah \w+ "?[^"]*"?$/,
  /^baca \w+$/,
  /^perbarui \w+ "?[^"]*"?$/,
  /^hapus \w+$/,
  /^isi \w+ "?[^"]*"?$/,
  /^cetak ".*?"$/,
  /^lanjut ke \w+$/,
  /^tampilkan_semua_data$/,
  /^simpan$/,
  /^muat$/,
  /^ambil semua dengan \w+ *(==|!=|>=|<=|>|<) *\d+$/,
  /^langkah \w+$/,
  /^selesai$/,
  /^mulai_dari \w+$/
]

def perintah_valid?(baris)
  VALID_COMMANDS.any? { |regex| baris.strip.match(regex) }
end

post '/jalankan' do
  content_type :json
  body = JSON.parse(request.body.read)
  baris = body["baris"]

  unless perintah_valid?(baris)
    status 400
    return { status: "error", pesan: "Perintah tidak valid: #{baris}" }.to_json
  end

  begin
    hasil = interpreter.jalankan(baris)
    { status: "ok", hasil: hasil }.to_json
  rescue => e
    status 500
    { status: "error", pesan: e.message }.to_json
  end
end

get '/data' do
  content_type :json
  interpreter.instance_variable_get(:@data).to_json
end

post '/isi' do
  content_type :json
  input = JSON.parse(request.body.read)
  kunci = input["kunci"]
  nilai = input["nilai"]

  unless kunci =~ /^\w+$/ && nilai.is_a?(String) || nilai.is_a?(Numeric)
    status 400
    return { status: "error", pesan: "Kunci atau nilai tidak valid" }.to json
  end

  interpreter.jalankan("isi #{kunci} \"#{nilai}\"")
  { status: "ok", data: interpreter.instance_variable_get(:@data) }.to_json
end

post '/cari' do
  content_type :json
  input = JSON.parse(request.body.read)
  pola = input["pola"]
  hasil = interpreter.instance_variable_get(:@data).select { |k, v| v.to_s.match(/#{pola}/) }
  { hasil: hasil }.to_json
end
