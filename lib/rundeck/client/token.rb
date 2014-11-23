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
      # @param  [id] The token id
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def token(id, options = {})
        objectify get("/token/#{id}", options)['token']
      end

      #
      # def create_token
      #
      # end
      #
      # def delete_token
      #
      # end
    end
  end
end
