# Assuming we want to make a simple networked chat class

class SimpleChat
  include Networking # This will attach all the networking logic to the class

  # Now we need to define a function that we use to send chat messages
  def send_message(nickname, message)
    # self.broadcast is attached with Networking module and will send this packet to all the connected
    # clients
    self.broadcast({
      type: "message",
      nickname: nickname,
      message: message
      })
  end

  # Every time we receive a packet of type "message" a method named: rpc_message will be invoked on this
  # instance and all the hash keys are mapped to parameters
  def rpc_message(type, nickname, message)
    puts "Chat > #{nickname}: #{message}"
  end
end
