module Rundeck
  class Client
    # Defines methods related to executions.
    module Execution
      # Execute a job
      #
      # @!macro has_optional_params
      #
      # @see http://rundeck.org/docs/api/index.html#running-a-job
      #   Rundeck API documentation for 'POST /api/12/job/[ID]/executions'
      #   endpoint
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

      # Get executions for a specific job.
      #
      # @!macro has_optional_params
      #
      # @see http://rundeck.org/docs/api/index.html#getting-executions-for-a-job
      #   Rundeck API documentation for 'GET /api/1/job/[ID]/executions'
      #   endpoint
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
      # @!macro has_required_params
      #
      # @see http://rundeck.org/docs/api/index.html#listing-running-executions
      #   Rundeck API documentation for 'GET /api/1/executions/running' endpoint
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
      # @see http://rundeck.org/docs/api/index.html#delete-all-executions-for-a-job
      #   Rundeck API documentation for 'DELETE /api/12/job/[ID]/executions'
      #   endpoint
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

      # Delete an execution
      #
      # @see http://rundeck.org/docs/api/index.html#delete-an-execution
      #   Rundeck API documentation for 'DELETE /api/12/execution/[ID]' endpoint
      #
      # @param  [String] id Execution id
      # @!macro options
      # @return [nil] If the delete was successful
      # @!macro exceptions
      def delete_execution(id, options = {})
        delete("/execution/#{id}", options)
      end

      # Abort a running execution
      #
      # @!macro has_optional_params
      #
      # @see http://rundeck.org/docs/api/index.html#aborting-executions
      #   Rundeck API documentation for 'POST /api/1/execution/[ID]/abort'
      #   endpoint
      #
      # @param  [String] id Execution id
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @!macro exceptions
      def abort_execution(id, options = {})
        objectify post("/execution/#{id}/abort", options)['abort']
      end

      # Get info for an execution
      #
      # @see http://rundeck.org/docs/api/index.html#execution-info
      #   Rundeck API documentation for 'GET /api/1/execution/[ID]' endpoint
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

      # Bulk delete executions
      #
      # @see http://rundeck.org/docs/api/index.html#bulk-delete-executions
      #   Rundeck API documentation for 'POST /api/12/executions/delete'
      #
      # @param  [String] ids An array of execution ids to delete
      # @!macro options
      # @return [Rundeck::ObjectifiedHash]
      # @raise  [Rundeck::Error::InvalidAttribites] if ids is not an array
      # @!macro exceptions
      def bulk_delete_executions(ids, options = {})
        unless ids.is_a?(Array)
          fail Rundeck::Error::InvalidAttributes, '`ids` must be an array of ids'
        end

        options[:query] = {} if options[:query].nil?
        options[:query].merge!(ids: ids.join(','))
        objectify post('/executions/delete', options)['deleteExecutions']
      end

      # def execution_state(id, options = {})
      #
      # end
      #
      # def execution_query(options = {})
      #
      # end
      #
      # def execution_output()
      #
      # end
      #
      # def execution_output_with_state()
      #
      # end
    end
  end
end
