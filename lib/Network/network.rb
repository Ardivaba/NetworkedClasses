require_relative "include"

# Responsible for networking
module Network
  @@id = SecureRandom.uuid
  def self.connection_id
    @@id
  end

  @@is_host = false
  def self.is_host
    @@is_host
  end

  def self.net
    @net
  end

  @@client_connections = {}
  def self.client_connection(type, connection_id)
    puts "Client with id: #{connection_id} connected"
  end

  def self.client_spawn(type, class_name, args)
    class_object = Object.const_get(class_name)
    replicated_object = class_object.new(*args)
    puts replicated_object.identity
  end

  # Are we connected to the network?
  def self.connected
    true
  end

  def self.host(port)
    @@is_host = true
    @net = NetworkHost.new(nil, port)
  end

  def self.join(ip, port)
    @net = NetworkClient.new(ip, port)

    #self.broadcast({
    #  type: "connection",
    #  connection_id: Network.connection_id
    #  })
  end

  # Broadcasts packet to all other connected parties
  def self.broadcast(packet)
    # puts "Broadcasting packet: #{packet}"
    @net.send_raw(packet)
  end

  def self.register_object(object)

  end

  # Listeners static field
  @@listeners = []
  def self.listeners
    @@listeners
  end

  # Register listener that will get network events
  def self.register_listener(object)
    @@listeners << object
    puts "Registered #{object.class} as EventListener"
  end

  # Is this even the right place, i'd assume not
  @@connection_manager = ConnectionManager.new
  @@object_manager = ObjectManager.new

  def self.object_manager
    @@object_manager
  end

  def self.connection_manager
    @@connection_manager
  end
end
