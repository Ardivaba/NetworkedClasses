class SimpleChat
  include Networked

  def initialize(*params)
    super(*params)
  end

  def send_message(nickname, message)
    self.broadcast({
      type: "chat_message",
      nickname: nickname,
      message: message
      })
  end

  def rpc_chat_message(type, nickname, message)
    puts "#{nickname}: #{message}"
  end
end
