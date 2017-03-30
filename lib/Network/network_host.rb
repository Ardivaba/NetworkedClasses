# Handles connection and network state managment with clients

module Network
  # Connected client, primarily enables a way to communicate with a single client
  class Client
  end

  class NetworkHost < NetworkBase
    def packet(packet, net_id)
      puts "#{net_id[2]}:#{net_id[1]}: #{packet}"
    end
  end
end
