module Rundeck
  class Client
    # Defines methods related to projects.
    module Jobs
      # Gets a list of jobs for a specific project.
      #
      # @example
      #   Rundeck.jobs('project')
      #
      # @param  [String] project Project name
      # @param  [Hash] options A customizable set of options.
      #
      # @todo what options can we use?
      # @option options [String] :scope Scope of projects. 'owned' for list of projects owned by the authenticated user, 'all' to get all projects (admin only)
      #
      #
      # @return [Array<Rundeck::ObjectifiedHash>]
      def jobs(project, options = {})
        objectify get("/project/#{project}/jobs", options)['jobs']['job']
      end
    end
  end
end
