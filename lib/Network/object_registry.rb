class ObjectRegistry
  def initialize
    @objects = []
  end

  def register_object(object)
    @objects << object
    puts "Object #{object.identity} registered with owner #{object.owner}"
  end
end
