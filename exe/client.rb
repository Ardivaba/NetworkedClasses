require_relative "../lib/Network/network"
require_relative "../lib/Network/networked_entity"

# Join udp server with ip and port
Network.join("127.0.0.1", 8088)
# Create new networked entity

client_player = NetworkedEntity.new(10, 10)

# Temporary hack to keep the application going, thread will be kept alive by game engine in future
while true
end
