module Rundeck
  # Converts hashes to the objects.
  class ObjectifiedHash
    # Creates a new ObjectifiedHash object.
    def initialize(hash)
      @hash = hash
      @data = hash.each_with_object({}) do |(key, value), data|
        value = ObjectifiedHash.new(value) if value.is_a? Hash
        data[key.to_s] = value
        data
      end
    end

    def to_hash
      @hash
    end
    alias_method :to_h, :to_hash

    # Delegate to ObjectifiedHash.
    def method_missing(key)
      @data.key?(key.to_s) ? @data[key.to_s] : nil
    end
  end
end
