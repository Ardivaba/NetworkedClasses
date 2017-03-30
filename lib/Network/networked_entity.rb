# Example class that i'm building my logic around
class NetworkedEntity
  include Networked

  # net_ prefixed fields will get replicated automatically over the network
  attr_accessor :net_id, :net_x, :net_y, :x, :y

  # Initialize entity with x, y coordinates
  def initialize(*args)
    @x, @y = *args
    @net_x = @x
    @net_y = @y

    super(*args) # Calls networked initialize
  end

  # Called if object is owned by us
  def owner_update
    @net_x = @x
    @net_y = @y
  end

  # Called if object is owned by others
  def remote_update
    @x = @synced_x
    @y = @synced_y
  end
end
