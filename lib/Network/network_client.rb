# Handles connection and network state managment with server

module Network
  class Client
  end

  class NetworkClient < NetworkBase
    def packet(packet, net_id)
      puts "Packet for client..."
    end
  end
end
