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
      # @param  [Hash] options A set of options passed directly to HTTParty
      # @return [Array<Rundeck::ObjectifiedHash>]
      def jobs(project, options = {})
        objectify get("/project/#{project}/jobs", options)['jobs']['job']
      end

      # Gets a single job by id
      #
      # @example Rundeck.job('c07518ef-b697-4792-9a59-5b4f08855b67')
      #
      # @param  [String] id Job id
      # @param  [Hash] options A set of options passed directly to HTTParty
      # @return [Rundeck::ObjectifiedHash]
      def job(id, options = {})
        objectify get("/job/#{id}", options)['joblist']['job']
      end

      # Get executions for a specific job
      #
      # @example
      #   Rundeck.job_executions('c07518ef-b697-4792-9a59-5b4f08855b67')
      #
      # @param  [String] id Job id
      # @param  [Hash] options A set of options passed directly to HTTParty
      # @return [Rundeck::ObjectifiedHash]
      def job_executions(id, options = {})
        r = get("/job/#{id}/executions", options)['result']['executions']['execution']
        objectify r
      end

      # Run a job
      #
      # @example
      #   Rundeck.job_run('c07518ef-b697-4792-9a59-5b4f08855b67', 'DEBUG')
      #
      # @param  [String] id Job id
      # @param  [Hash]   options A set of options passed directly to HTTParty
      # @return [Rundeck::ObjectifiedHash]
      def job_run(id, options = {})
        objectify post("/job/#{id}/executions", options)['result']['executions']['execution']
      end

      # Export jobs to yaml or xml format
      #
      # @example
      #   Rundeck.jobs_export('project')
      #
      # @param  [String] project Project name
      # @param  [String] format The export format. 'yaml|xml', defaults to 'yaml'
      # @param  [Hash]   options A set of options passed directly to HTTParty
      # @return [String]
      def jobs_export(project, format = 'yaml', options = {})
        unless format =~ /yaml|xml/
          fail Error::InvalidAttributes, 'format must be yaml or xml'
        end
        options[:query] = {} if options[:query].nil?
        options[:query].merge!('project' => project, 'format' => format)
        options[:format] = format

        get('/jobs/export', options)
      end
    end
  end
end
