# modules/method_missing.rb

class Wadah
  def initilize
    @data = {}
    @actions = []
  end

  def method_missing(name, *args, &block)
    if block_given?
      puts "Block untuk #{name}"
      @actions << { name: name, block: block }
    else
      @data[name] = args.first
    end
  self
end

def jalankan
  @actions.each do |a|
    puts "Menjalankan #{a[:name]}"
    instance_eval(&a[:block])
  end
end

def tampilan(isi = nil)
  puts isi || @data.inspect
  end
end
