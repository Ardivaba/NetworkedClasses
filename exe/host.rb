require_relative "../lib/Network/network"

# Host udp server and listen on 8088
Network.host(8088)

# Temporary hack to keep the application going, thread will be kept alive by game engine in future
while true
end
