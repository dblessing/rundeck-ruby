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

      # Delete a job
      #
      # @example
      #   Rundeck.delete_job('c07518ef-b697-4792-9a59-5b4f08855b67')
      #
      # @param  [String] id Job id
      # @param  [Hash] options A set of options passed directly to HTTParty
      # @return [Rundeck::ObjectifiedHash]
      def delete_job(id, options = {})
        delete("/job/#{id}", options)
      end

      # Import a job or multiple jobs
      #
      # @example
      #   job = "- id: c07518ef-b697-4792-9a59-5b4f08855b67
      #            project: Endeca
      #            ..."
      #   Rundeck.import_jobs(job)
      #
      # @example
      #   job = "<joblist>
      #            <job>
      #              <id>c07518ef-b697-4792-9a59-5b4f08855b67</id>
      #              ..."
      #   Rundeck.import_jobs(job, 'xml')
      #
      # @param  [String] content The job definition(s) as yaml or xml
      # @param  [String] format The import format. 'yaml|xml', defaults to 'yaml'
      # @param  [Hash]   options A set of options passed directly to HTTParty
      # @return [Rundeck::ObjectifiedHash]
      def import_jobs(content, format = 'yaml', options = {})
        unless format =~ /yaml|xml/
          fail Error::InvalidAttributes, 'format must be yaml or xml'
        end
        options[:headers] = {} if options[:headers].nil?
        options[:headers].merge!(
            'Content-Type' => 'application/x-www-form-urlencoded')
        options[:body] = "xmlBatch=#{content}"
        options[:query] = {} if options[:query].nil?
        options[:query]['format'] = format

        objectify post('/jobs/import', options)['result']
      end

      # Export jobs to yaml or xml format
      #
      # @example
      #   Rundeck.export_jobs('project')
      #
      # @param  [String] project Project name
      # @param  [String] format The export format. 'yaml|xml', defaults to 'yaml'
      # @param  [Hash]   options A set of options passed directly to HTTParty
      # @return [String]
      def export_jobs(project, format = 'yaml', options = {})
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
