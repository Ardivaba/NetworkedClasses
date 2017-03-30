module Network
  class NetworkBase
    attr_reader :socket

    def initialize(ip, port)
      @socket = UDPSocket.new
      @ip = ip
      @port = port

      # Nil ip is assuming that we're creating a host
      if ip == nil
        @socket.bind(nil, port)
      end

      self.network_thread
    end

    def send_raw(data)
      @socket.send(data.to_json, 0, @ip, @port)
    end

    def packet(packet, net_id)
    end

    def network_thread()
      puts "Listening for packets..."
      Thread.new do
        Thread.abort_on_exception = true
        while Network.connected
          data_json, sender = @socket.recvfrom(1024)
          data = JSON.parse(data_json)
          self.packet(data, sender)
        end
      end
    end
  end
end
