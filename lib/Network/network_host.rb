module Network
  # Connected client, primarily enables a way to communicate with a single client
  class Client
  end

  # Handles connection and network state managment with clients
  class NetworkHost < NetworkBase
    attr_accessor :packet_buffer
    def initialize(ip, port)
      super(ip, port)
      @packet_buffer = []
    end

    def packet(packet, net_id)
      @packet_buffer << packet

      # puts "#{net_id[2]}:#{net_id[1]}: #{packet}"
      self.send_raw(packet, packet["identity"])
      super(packet, net_id)
    end

    def send_raw(data, exclude = nil)
      Network.connection_manager.connections.each do |id, addr|
        if exclude != id
          @socket.send(data.to_json, 0, addr[0], addr[1])
        end
      end
    end
  end
end
