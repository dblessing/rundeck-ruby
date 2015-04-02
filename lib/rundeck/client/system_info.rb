module Rundeck
  class Client
    # Defines methods related to projects.
    module SystemInfo
      # Get the complete system info
      #
      # @see http://rundeck.org/docs/api/index.html#system-info
      #   Rundeck API documentation for 'GET /api/12/system/info' endpoint
      #
      # @example
      #   Rundeck.system_info
      #
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def system_info
        objectify get('/system/info')
      end
    end
  end
end
