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
        objectify get('/projects', options)['projects']
      end

      # Create a project
      #
      # @see http://rundeck.org/docs/api/index.html#project-creation
      #   Rundeck API documentation for 'POST /api/11/projects' endpoint
      #
      # @example
      #   @TODO: Example
      #
      # @param  [String] content The job definition(s) as yaml or xml
      # @param  [String] format The project creation format. 'json|xml',
      #   defaults to 'json'
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      # def create_project(content, format = 'json', options = {})
      #   unless format =~ /json|xml/
      #     fail Error::InvalidAttributes, 'format must be yaml or xml'
      #   end
      #   options[:headers] = {} if options[:headers].nil?
      #   options[:headers].merge!(
      #       'Content-Type' => 'application/x-www-form-urlencoded')
      #   options[:body] = "xmlBatch=#{content}"
      #   options[:query] = {} if options[:query].nil?
      #   options[:query]['format'] = format
      #
      #   objectify post('/jobs/import', options)['result']
      # end

      # Get a project by name
      #
      # @see http://rundeck.org/docs/api/index.html#getting-project-info
      #   Rundeck API documentation for 'GET /api/1/project/[NAME]' endpoint
      #
      # @example
      #   Rundeck.project('anvils')
      #
      # @param  [String] name The project name
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def project(name, options = {})
        objectify get("/project/#{name}", options)['project']
      end

      # Delete a project
      #
      # @see http://rundeck.org/docs/api/index.html#project-deletion
      #   Rundeck API documentation for 'DELETE /api/11/project/[NAME]' endpoint
      #
      # @example
      #   Rundeck.delete_project('my_project')
      #
      # @param  [String] name The project name
      # @!macro options
      # @return nil
      # @!macro exceptions
      def delete_project(name, options = {})
        objectify delete("/project/#{name}", options)
      end
    end
  end
end
