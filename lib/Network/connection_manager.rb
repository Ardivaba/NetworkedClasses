class ConnectionManager
  attr_reader :connections

  def initialize
    Network.register_listener(self)
    @connections = {}
  end

  def net_connection(type, connection_id, ip, port)
    puts "#{connection_id} connected from #{ip}:#{port}"
    @connections[connection_id] = [ip, port]

    if Network.is_host
      # puts "Replay of length: #{Network.net.packet_buffer.length}"
      for packet in Network.net.packet_buffer
        Network.net.socket.send(packet.to_json, 0, ip, port)
      end
    end
  end
end
