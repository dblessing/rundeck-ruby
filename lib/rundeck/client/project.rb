module Rundeck
  class Client
    # Defines methods related to projects.
    module Project
      # Get all projects
      #
      # @see http://rundeck.org/docs/api/index.html#listing-projects
      #   Rundeck API documentation for 'GET /api/1/projects' endpoint
      #
      # @example
      #   Rundeck.projects
      #
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def projects(options = {})
        projects = objectify get('/projects', options)['projects']
        objectify projects.project
      end
    end
  end
end
