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
        objectify get("#{STORAGE_KEYS_PATH}/#{path}", options)
      end

      # Create a private key
      #
      # @example
      #   key = "-----BEGIN RSA PRIVATE KEY-----\nProc-Type:..."
      #   Rundeck.create_private_key('path', key)
      #
      # @param  [String] path A key storage path
      # @param  [String] key The entire private key value
      # @param  [Hash] options A set of options passed directory to HTTParty
      # @return [Array<Rundeck::ObjectifiedHash>]
      def create_private_key(path, key, options = {})
        options.merge!(body: key,
                       headers: { 'Content-Type' => 'application/octet-stream' })
        objectify post("#{STORAGE_KEYS_PATH}/#{path}", options)
      end
    end
  end
end
