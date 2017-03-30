require_relative "include"

# Responsible for networking
module Network
  attr_reader :owner_id

  @@id = SecureRandom.uuid
  def self.connection_id
    @@id
  end

  @@is_host = false
  def self.is_host
    is_host
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

  # Starts socket and thread for host. ! Unused, here just for reference, that is managed by NetworkHost now
  def self._host(port)
    @socket = Socket.udp_server_loop(port) do |data, src|
      packet = JSON.parse(data)

      if packet["channel"] == "setup"
        case packet["type"]
        when "connection"
          self.client_connection(*packet.value, src)
        end
      else
        self.send("client_#{packet["type"]}", *packet.values)
      end
    end
  end

  # Are we connected to the network?
  def self.connected
    true
  end

  def self.host(port)
    @@is_host = true
    @net = NetworkHost.new(nil, port)
  end

  # Starts socket and thread for client ! Unused, here just for reference, that is managed by NetworkClient now
  def self._join(ip, port)
    @ip = ip
    @port = port
    @socket = UDPSocket.new

    self.broadcast(({
      type: "connection",
      connection_id: Network.connection_id
      }))
  end

  def self.join(ip, port)
    @net = NetworkClient.new(ip, port)

    self.broadcast({
      type: "connection",
      connection_id: Network.connection_id
      })
  end

  # Broadcasts packet to all other connected parties
  def self.broadcast(packet)
    puts "Broadcasting packet: #{packet}"
    @net.send_raw(packet)
  end

  def self.register_object(object)

  end
end
