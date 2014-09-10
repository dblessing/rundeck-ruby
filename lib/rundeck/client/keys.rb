module Rundeck
  class Client
    # Defines methods related to projects.
    module Keys
      STORAGE_KEYS_PATH = '/storage/keys'

      # Gets a list keys at a specific path.
      #
      # @example
      #   Rundeck.keys('path')
      #
      # @param  [String] path A key storage path
      # @param  [Hash] options A set of options passed directly to HTTParty
      # @return [Array<Rundeck::ObjectifiedHash>]
      def keys(path, options = {})
        get("#{STORAGE_KEYS_PATH}/#{path}", options)
      end

      def create_private_key(path, key)
        post("#{STORAGE_KEYS_PATH}/#{path}",
             body: key,
             headers: { 'Content-Type' => 'application/octet-stream' })
      end
    end
  end
end
