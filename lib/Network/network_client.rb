# Handles connection and network state managment with server

module Network
  class Client
  end

  class NetworkClient < NetworkBase
    def initialize(ip, port)
      super(ip, port)

      self.send_raw({
          type: "connection",
          connection_id: Network.connection_id
        })
    end

    def packet(packet, net_id)
      puts packet
      super(packet, net_id)
    end
  end
end
