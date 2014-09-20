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
      # @param  [String] loglevel The loglevel for job output
      # @param  [String] user The user the run the job as
      # @param  [String] args argument string to pass to the job
      # @param  [Hash]   node_filter The node filter options
      # @param  [Hash]   options A set of options passed directly to HTTParty
      # @return [Rundeck::ObjectifiedHash]
      def job_run(id, loglevel = 'INFO', user = nil, args = nil, node_filter = {}, options = {})
        options[:query] = { 'loglevel'   => loglevel }
        options[:query]['asUser'] = user unless user.nil?
        options[:query]['argString'] = args unless args.nil?
        options[:query].merge!(node_filter)

        objectify post("/job/#{id}/executions", options)['result']['executions']['execution']
      end
    end
  end
end
