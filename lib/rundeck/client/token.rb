module Rundeck
  class Client
    # Defines methods related to managing security.
    module Token
      # List all tokens, or all tokens for a specific user.
      #
      # @example
      #   Rundeck.tokens
      #
      # @example
      #   Rundeck.tokens('admin')
      #
      # @param  [String] user List tokens for this user.
      # @!macro options
      # @return [Rundeck::ObjectifiedHash] if there is only a single token
      # @return [Array<Rundeck::ObjectifiedHash>] if there are multiple tokens
      # @!macro exceptions
      def tokens(user = nil, options = {})
        path = user.nil? ? '/tokens' : "/tokens/#{user}"
        objectify get(path, options)['tokens']
      end

      # Get a specific token
      #
      # @example
      #   Rundeck.token('admin')
      #
      # @param  [String] id The token id
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def token(id, options = {})
        objectify get("/token/#{id}", options)['token']
      end

      # Create a new token for a user
      #
      # @example
      #   Rundeck.create_token('user1')
      #
      # @param  [String] user Create a token for this user
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def create_token(user, options = {})
        objectify post("/tokens/#{user}", options)['token']
      end

      # Delete a token
      #
      # @example
      #   Rundeck.delete_token('cmJQYoy9EAsSd0905yNjKDNGs0ESIwEd')
      #
      # @param  [String] id The token id
      # @!macro options
      # @return nil
      # @!macro exceptions
      def delete_token(id, options = {})
        delete("/token/#{id}", options)
      end
    end
  end
end
