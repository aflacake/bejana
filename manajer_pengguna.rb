# manajer_pengguna.rb

require 'json'
require 'securerandom'

module UserManager
  USERS_FILE = "pengguna.json"

  def self.load_users
    if File.exist?(USERS_FILE)
      JSON.parse(File.read(USERS_FILE))
    else
      { "users" => [] }
    end
  end

  def self.save_users(data)
    File.write(USERS_FILE, JSON.pretty_generate(data))
  end

  def self.find_user_by_token(token)
    data = load_users
    data["users"].find { |u| u["token"] == token }
  end

  def self.generate_token_for(username)
    data = load_users
    user = data["users"].find { |u| u["username"] == username }

    if user.nil?
      user = { "username" => username }
      data["users"] << user
    end

    new_token = SecureRandom.hex(16)
    user["token"] = new_token

    save_users(data)
    new_token
  end

  def self.list_users
    load_users["users"].map { |u| { username: u["username"], token: u["token"] } }
  end

  def self.find_user_by_token(token)
    data = load_user
    data["users"].find { |u| u["token"] == token }
  end

  def self.user_role(token)
    user = find_user_by_token(token)
    user ? user["role"] : nil
  end
end
