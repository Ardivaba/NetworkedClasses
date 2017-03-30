module Networked
  attr_reader :is_mine, :identity
  def initialize(*args)
    if args.last() == -1
      @owner = args.last(3)[0]
      @identity = args.last(3)[1]
      @is_mine = false

      puts "Spawned remote object Owner: #{@owner} Identity: #{@identity}"
    else
      puts "Spawned original object"
      @identity = SecureRandom.uuid
      @owner = Network.connection_id
      self.spawn_object(*args)

      @is_mine = true
    end

    Network.register_object(self)
  end

  # Applies replicated fields
  def apply_fields(fields)
    fields.each do |key, value|
      self.instance_variable_set(key, value) # MAGIC, using strings to set fields on instance
    end
  end

  # Broadcasts spawn event with net vars
  def spawn_object(*args)
    puts "Spawning entity: #{self} with id #{self.net_id}"

    # Broadcast spawn packet with networked fields
    Network.broadcast({
      type: "spawn",
      class: self.class.to_s,
      args: args << Network.connection_id << self.identity << -1
      })
  end

  # Enumerate all instance fields, then create hash for fields that have net_ prefix
  def get_net_fields
    networked_fields = {}
    for field in self.instance_variables
      if field.to_s.include?("net_")
        networked_fields[field.to_s] = self.instance_eval(field.to_s) # MAGIC, using strings to access fields on instance
      end
    end

    networked_fields
  end

  # Syncronizes all net_ vars
  def sync
    fields = self.get_net_fields
    self.broadcast({
        type: "sync_fields",
        fields: get_net_fields
      })
  end

  # Attaches identity to the packet and then broadcasts it
  def broadcast(packet)
    packet["identity"] = @identity
    Network.broadcast(packet)
  end
end
