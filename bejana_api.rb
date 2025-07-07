# bejana_api.rb

require 'sinatra'
require 'json'

require_relative 'bejana_interpreter'
require_relative 'manajer_pengguna'

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

before do
  # Cek token di header Authorization: Bearer TOKEN
  token = request.env["HTTP_AUTHORIZATION"]&.split(' ')&.last
  unless token && UserManager.find_user_by_token(token)
    halt 401, { status: "error", pesan: "Unauthorized: Token tidak ditemukan atau salah" }.to_json
  end
end

def perintah_valid?(baris)
  VALID_COMMANDS.any? { |regex| baris.strip.match(regex) }
end

def simpan_data_automatis
  interpreter.send(:simpan_ke_file)
end

post '/jalankan' do
  require_role("admin")

  content_type :json
  body = JSON.parse(request.body.read)
  baris = body["baris"]

  unless perintah_valid?(baris)
    status 400
    return { status: "error", pesan: "Perintah tidak valid: #{baris}" }.to_json
  end

  begin
    hasil = interpreter.jalankan(baris)
    simpan_data_automatis
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
  require_role("admin", "editor")

  content_type :json
  input = JSON.parse(request.body.read)
  kunci = input["kunci"]
  nilai = input["nilai"]

  unless kunci =~ /^\w+$/ && (nilai.is_a?(String) || nilai.is_a?(Numeric))
    status 400
    return { status: "error", pesan: "Kunci atau nilai tidak valid" }.to_json
  end

  interpreter.jalankan("isi #{kunci} \"#{nilai}\"")
  simpan_data_automatis
  { status: "ok", data: interpreter.instance_variable_get(:@data) }.to_json
end

post '/cari' do
  content_type :json
  input = JSON.parse(request.body.read)
  pola = input["pola"]
  hasil = interpreter.instance_variable_get(:@data).select { |k, v| v.to_s.match(/#{pola}/) }
  { hasil: hasil }.to_json
end

get '/users' do
  content_type :json
  UserManager.list_users.to_json
end

post '/generate_token' do
  content_type :json
  input = JSON.parse(request.body.read)
  username = input["username"]

  unless username =~ /^\w+$/
    status 400
    return { status: "error", pesan: "Username tidak valid" }.to_json
  end

  token = UserManager.generate_token_for(username)
  { status: "ok", username: username, token: token }.to_json
end

helpers do
  def current_user
    token = request.env["HTTP_AUTHORIZATION"]&.split(' ')&.last
    UserManager.find_user_by_token(token)
  end

  def require_role(*roles)
    unless current_user && roles.include?(current_user["role"])
      halt 403, { status: "error", pesan: "Dilarang: Akses ditolak" }.to_json
    end
  end
end
