module Rundeck
  class Client
    # Defines methods related to projects.
    module Keys
      STORAGE_KEYS_PATH = '/storage/keys'

      # Gets a list of keys at a specific path.
      #
      # @example
      #   Rundeck.keys('path')
      #
      # @param  [String] path A key storage path
      # @param  [Hash] options A set of options passed directly to HTTParty
      # @return [Array<Rundeck::ObjectifiedHash>]
      def keys(path = '', options = {})
        r = get("#{STORAGE_KEYS_PATH}/#{path}", options)

        #         # In case a user provides a direct path to a key, error.
        if r['resource']['contents']
          objectify r['resource']['contents']['resource']
        else
          fail Error::InvalidAttributes,
               'Please provide a key storage path that ' \
               'isn\'t a direct path to a key'
        end
      end

      # Get a single key's metadata
      #
      # @example
      #   Rundeck.key_metadata('path/to/key1')
      #
      # @param  [String] path A key storage path, including key name
      # @param  [Hash] options A set of options passed directly to HTTParty
      # @return [Rundeck::ObjectifiedHash]
      def key_metadata(path, options = {})
        r = get("#{STORAGE_KEYS_PATH}/#{path}", options)

        # In case a user provides a key path instead of a path to a single key.
        if r['resource']['contents']
          fail Error::InvalidAttributes,
               'Please provide a key storage path that ' \
               'is a direct path to a key'
        else
          objectify r['resource']['resource_meta']
        end
      end

      # Get the contents of a key. Only allowed for public keys.
      # Note: This method returns a raw string of the public key,
      # not at ObjectifiedHash.
      #
      # @example
      #   Rundeck.key_contents('path/to/key1')
      #
      # @param  [String] path A key storage path, including key name
      # @param  [Hash] options A set of options passed directly to HTTParty
      # @return [String]
      def key_contents(path, options = {})
        # Check if key exists first. Otherwise we could return some
        # weird strings. Also, raise error if user is trying to get a
        # private key.
        if key_metadata(path, options).rundeck_key_type == 'private'
          fail Error::Unauthorized,
               'You are not allowed to retrieve the contents of a private key'
        end


        options.merge!(headers: { 'Accept' => 'application/pgp-keys' },
                       format: :plain)
        get("#{STORAGE_KEYS_PATH}/#{path}", options)
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
