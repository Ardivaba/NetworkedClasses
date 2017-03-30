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

    def send_raw(packet)
      if packet["type"] == "spawn"
        @cached_spawn_packets << packet
        puts "Cached spawn packet fo #{self.class}"
      end

      @socket.send(packet.to_json, 0, @ip, @port)
    end

    def packet(packet, net_id)
      # Invoke event methods on listeners
      Network.listeners.each do |object|
        begin
          object.send("net_any", packet)
        rescue
        end

        begin
          object.send("net_" + packet["type"], *packet.values)
        rescue StandardError => error
          #puts "DEBUG: Failed to invoke net_#{packet["type"]} on #{object.class}"
          #puts "---"
          # => puts error
          #puts "---"
        end
      end
    end

    def network_thread()
      puts "Listening for packets..."
      Thread.new do
        Thread.abort_on_exception = true
        while Network.connected
          begin
          data_json, sender = @socket.recvfrom(1024)
          data = JSON.parse(data_json)

          # LAME Hack, but we only need to get packet source once
          if data["type"] == "connection"
            data["ip"] = sender[2]
            data["port"] = sender[1]
          end

          self.packet(data, sender)
          rescue
          end
        end
      end
    end
  end
end
