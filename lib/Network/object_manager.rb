class ObjectManager
  attr_accessor :objects, :cached_spawn_packets

  def initialize
    Network.register_listener(self)
    @objects = []
    @cached_spawn_packets = []
  end

  def net_any(packet)
    if packet["type"] == "spawn"
      @cached_spawn_packets << packet
      puts "Cached spawn packet fo #{self.class}"
    end

    @objects.each do |object|
      #puts "Comparing #{object.identity} against #{packet["identity"]}"
      if object.identity == packet["identity"]
        packet.delete("identity")
        object.send("rpc_#{packet['type']}", *packet.values)
      end
    end
  end

  def net_spawn(type, class_name, args)
    info_data = args.take(3)

    class_object = Object.const_get(class_name)
    replicated_object = class_object.new(*args)

    #@objects << replicated_object

    puts "Replicated object: #{replicated_object}"
    # puts "Replicated object info: #{replicated_object.info}"
  end

  def find_instance(clazz)
    @objects.each do |object|
      #puts "Comparing #{object.identity} against #{packet["identity"]}"
      if object.class == clazz
        puts "Found #{clazz} object #{object}"
        return object
      end
    end
  end
end
