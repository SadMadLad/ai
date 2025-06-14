class MemoryUtils
  class << self
    def allocations
      raise ArgumentError, "No block given" unless block_given?

      starting = GC.stat(:total_allocated_objects)

      yield

      GC.stat(:total_allocated_objects) - starting
    end
  end
end
