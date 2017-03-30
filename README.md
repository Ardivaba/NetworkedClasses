```ruby
# Example usage of Networked include
# First include network
require_relative "Network/network"

# Create a class that you whish to network
class Chat
  include Networked # Include 'networked' to add the magic

  attr_reader :messages

  # Limit chat history to some number
  # Constructor variables get replicated
  def initialize(history_length)
    @history_length = history_length
    @net_messages = [] # Fields with net_ prefix will get syncronized automatically inside an update loop
  end

  # Send message over network
  def send_message(name, message)
    self.broadcast({
      type: "chat_message",
      name: name
      message: message
      })
  end

  # Receive message from network (or yourself), packet events are sent to instance
  # using: 'net_' + packet["type"]
  # Parameters are unpacked from the map you send using self.broadcast
  def net_message(name, message)
    @messages << "#{name}: #{message}"
    # Remove last element from messages history
    if messages.length > @history_length
      messages.shift
      messages.pop
    end
  end
end

# When you instantiate a class it will automatically get instantiated on all clients,
# constructor parameters too get replicated.
# Whichever computer starts the instance will own the instance, when computer
# disconnects from the netwok all of his objects will get destroyed
# in chat's case it makes sense that host will own the instance.
if Network.is_host
  chat = Chat.new(10)
  chat.send_message("Server", "Hello from host!")
else
  chat = Network.find_instance(Chat.class)
  chat.send_message("Client", "Hello from client!")
end

# Ideally simply this code should enable you to have networked chat without worrying
# about common networking problems.
```
