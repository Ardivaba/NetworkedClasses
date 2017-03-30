require_relative "../lib/Network/network"

# Host udp server and listen on 8088
Network.host(8088)

# Temporary hack to keep the application going, thread will be kept alive by game engine in future

puts "Press enter to start..."
# After we press enter SimpleChat is instantiated
gets
chat = SimpleChat.new

while true
  chat.send_message("Host", gets)
end
