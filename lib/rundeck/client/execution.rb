module Rundeck
  class Client
    # Defines methods related to executions.
    module Execution
      # Execute a job
      #
      # @example
      #   Rundeck.execute_job('c07518ef-b697-4792-9a59-5b4f08855b67')
      #   Rundeck.run_job('c07518ef-b697-4792-9a59-5b4f08855b67')
      #
      # @param  [String] id Job id
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def execute_job(id, options = {})
        objectify post("/job/#{id}/executions", options)['result']['executions']['execution']
      end
      alias_method :run_job, :execute_job

      # Get executions for a specific job
      #
      # @example
      #   Rundeck.job_executions('c07518ef-b697-4792-9a59-5b4f08855b67')
      #
      # @param  [String] id Job id
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def job_executions(id, options = {})
        r = get("/job/#{id}/executions", options)['result']['executions']['execution']
        objectify r
      end

      # Get all running job executions
      #
      # @example
      #   Rundeck.running_job_executions('anvils')
      #
      # @param  [String] project List running executions from this project
      # @!macro options
      # @return [nil] if no running executions
      # @return [Rundeck::ObjectifiedHash] if a single running job execution
      # @return [Array<Rundeck::ObjectifiedHash>] if multiple running job executions
      # @!macro exceptions
      def running_job_executions(project, options = {})
        options[:query] = {} if options[:query].nil?
        options[:query]['project'] = project
        r = get('/executions/running', options)

        if objectify(r['result']['executions']).count != '0'
          objectify r['result']['executions']['execution']
        else
          nil
        end
      end

      # Delete all executions for a specific job
      #
      # @example
      #   Rundeck.delete_job_executions('c07518ef-b697-4792-9a59-5b4f08855b67')
      #
      # @param  [String] id Job id
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def delete_job_executions(id, options = {})
        objectify delete("/job/#{id}/executions", options)['deleteExecutions']
      end

      # Get info for an execution
      #
      # @example
      #   Rundeck.execution('c07518ef-b697-4792-9a59-5b4f08855b67'')
      #
      # @param  [String] id Job id
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def execution(id, options = {})
        objectify get("/execution/#{id}", options)['result']['executions']['execution']
      end
    end
  end
end
