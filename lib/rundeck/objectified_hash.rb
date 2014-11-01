module Rundeck
  # Converts hashes to objects.
  class ObjectifiedHash
    # Creates a new ObjectifiedHash object.
    def initialize(hash)
      @hash = hash
      @data = hash.each_with_object({}) do |(key, value), data|
        value = if value.is_a?(Hash)
                  ObjectifiedHash.new(value)
                elsif value.is_a?(Array)
                  value.map { |e| ObjectifiedHash.new(e) }
                else
                  value
                end
        data[key.to_s.downcase] = value
        data
      end
    end

    # Return the original hash object
    #
    # @return [Hash] the original hash
    def to_hash
      @hash
    end
    alias_method :to_h, :to_hash

    # Respond if the requested method is a key in the data
    # hash.
    def method_missing(key)
      @data.key?(key.to_s) ? @data[key.to_s] : super
    end

    # Overload the parent method so this properly returns whether the
    # instance of this object responds to the given method.
    def respond_to?(method)
      @data.key?(method.to_s) || super
    end
  end
end
