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

        # In case a user provides a direct path to a key, error.
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
      # @return [Rundeck::ObjectifiedHash]
      def key_contents(path, options = {})
        # Check if key exists first. Otherwise we could return some
        # weird strings. Also, raise error if user is trying to get a
        # private key.
        if key_metadata(path, options).rundeck_key_type == 'private'
          fail Error::Unauthorized,
               'You are not allowed to retrieve the contents of a private key'
        end

        options.merge!(format: :plain,
                       headers: { 'Accept' => 'application/pgp-keys' })
        key = get("#{STORAGE_KEYS_PATH}/#{path}", options)
        objectify 'public_key' => key
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
      # @return [Rundeck::ObjectifiedHash]
      def create_private_key(path, key, options = {})
        create_or_update_key(path, key, 'private', 'post', options)
      end

      # Update a private key
      #
      # @example
      #   key = "-----BEGIN RSA PRIVATE KEY-----\nProc-Type:..."
      #   Rundeck.update_private_key('path', key)
      #
      # @param  [String] path A key storage path
      # @param  [String] key The entire private key value
      # @param  [Hash] options A set of options passed directory to HTTParty
      # @return [Rundeck::ObjectifiedHash]
      def update_private_key(path, key, options = {})
        key_check(path, 'private', options)
        create_or_update_key(path, key, 'private', 'put', options)
      end

      # Create a public key
      #
      # @example
      #   key = "ssh-rsa AAAA.....3MOj user@example.com"
      #   Rundeck.create_public_key('path/to/key', key)
      #
      # @param  [String] path A key storage path
      # @param  [String] key The entire private key value
      # @param  [Hash] options A set of options passed directory to HTTParty
      # @return [Array<Rundeck::ObjectifiedHash>]
      def create_public_key(path, key, options = {})
        create_or_update_key(path, key, 'public', 'post', options)
      end

      # Update a public key
      #
      # @example
      #   key = "ssh-rsa AAAA.....3MOj user@example.com"
      #   Rundeck.update_public_key('path/to/key', key)
      #
      # @param  [String] path A key storage path
      # @param  [String] key The entire private key value
      # @param  [Hash] options A set of options passed directory to HTTParty
      # @return [Array<Rundeck::ObjectifiedHash>]
      def update_public_key(path, key, options = {})
        key_check(path, 'public', options)
        create_or_update_key(path, key, 'public', 'put', options)
      end

      # Delete a key
      #
      # @example
      #   Rundeck.delete_key('path/to/key')
      #
      # @param  [String] path A key storage path
      # @param  [Hash] options A set of options passed directly to HTTParty
      # @return [nil]
      def delete_key(path, options = {})
        delete("#{STORAGE_KEYS_PATH}/#{path}", options)
      end

      private

      def key_check(path, key_type, options)
        content_type = content_type(key_type)
        # Check existence and type
        if key_metadata(path, options).rundeck_content_type != content_type
          fail Error::NotFound,
               "A #{type} key was not found at the specified path."
        end
      end

      def create_or_update_key(path, key, type, method, options)
        key_type_headers(type, options)
        options.merge!(body: key)

        if method == 'post'
          objectify post("#{STORAGE_KEYS_PATH}/#{path}", options)['resource']['resource_meta']
        elsif method == 'put'
          objectify put("#{STORAGE_KEYS_PATH}/#{path}", options)['resource']['resource_meta']
        end
      end

      def key_type_headers(type, options)
        options.merge!(headers: { 'Content-Type' => content_type(type) })
      end

      def content_type(key_type)
        if key_type == 'private'
          'application/octet-stream'
        elsif key_type == 'public'
          'application/pgp-key'
        else
          fail Error::InvalidAttributes,
               'Invalid key type specified. Must be public or private.'
        end
      end
    end
  end
end
