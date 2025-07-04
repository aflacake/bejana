# bejana_api.rb

require 'sinatra'
require 'json'

require_ relative 'bejana_interpreter'

interpreter = BejanaInterpreter.new

set :port, 4567
set, :bind, '0.0.0.0'

post '/jalankan' do
  content_type :json
  body = JSON.parse(request.body.read)
  baris = body["baris"]

  begin
    hasil = interpreter.jalankan(baris)
    { status: "ok", hasil: hasil }.to_json
  rescue => e
    status 400
    { status: "error", pesan: e.message }.to_json
  end
end

get ' /data' do
  content_type :json
  interpreter.instance_variable_get(:@data).to_json
end

post '/isi' do
  content_type :json
  input = JSON.parse(request.body.read)
  kunci = input["kunci"]
  nilai = input["nilai"]
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
