module Rundeck
  # Wrapper for the Rundeck REST API.
  class Client < API
    # Macros to simplify client method documentation.

    # @!macro [new] options
    #   @param  [Hash] options A set of options passed directly to HTTParty. See
    #     http://rubydoc.info/gems/httparty/HTTParty/ClassMethods
    #   @option options [Hash] :query The parameters to pass with the request
    #      Use this hash to specify Rundeck parameters.
    #      - +query: { project: 'anvils', id: '123456' }+

    # @!macro [new] exceptions
    #   @raise [Rundeck::Error::BadRequest] 400 error - Most likely indicates a
    #     required parameter is missing.
    #   @raise [Rundeck::Error::Unauthorized] 401 error - Unauthorized
    #   @raise [Rundeck::Error::Forbidden] 403 forbidden - ACL policies prevent
    #     accessing the given resource
    #   @raise [Rundeck::Error::NotFound] 404 not found - Indicates a resource
    #     could not be found at the location
    #   @raise [Rundeck::Error::MethodNotAllowed] 405 method not allowed - The
    #     request method is not allowed. This probably indicates a
    #     misconfiguration in a reverse proxy, such as Nginx or Apache
    #   @raise [Rundeck::Error::Conflict] 409 conflict - A conflicting resource
    #     exists.
    #   @raise [Rundeck::Error::InternalServerError] 500 server error -
    #     Indicates the Rundeck server experienced an error.
    #   @raise [Rundeck::Error::BadGateway] 502 bad gateway - Indicates
    #     something probably isn't working right or is misconfigured on the
    #     Rundeck server.
    #   @raise [Rundeck::Error::ServiceUnavailable] 503 error - Indicates an
    #     issue on the Rundeck server.

    # @!macro [new] has_optional_params
    #   @note This method has optional Rundeck parameters that can be passed
    #     to the options parameter. See Rundeck API documentation
    #     for more information.
    #     - +query: { param1: 'value', param2: 'value' }+

    # @!macro [new] has_required_params
    #   @note This method has required Rundeck parameters that can be passed
    #     to the options parameter. See Rundeck API documentation
    #     for more information.
    #     - +query: { param1: 'value', param2: 'value' }+

    # @!macro [new] has_required_and_optional_params
    #   @note This method has both required and optional Rundeck parameters that
    #     can be passed to the options parameter. See Rundeck API documentation
    #     for more information.
    #     - +query { param1: 'value', param2: 'value' }+

    Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

    include Execution
    include Job
    include Key

    # Turn a hash into an object for easy accessibility.
    #
    # @note This method will objectify nested hashes/arrays.
    #
    # @param  [Hash, Array] result An array or hash of results to turn into
    #   an object
    # @return [Rundeck::ObjectifiedHash] if +result+ was a hash
    # @return [Rundeck::ObjectifiedHash] if +result+ was an array
    # @raise  [Array<Rundeck::Error::Parsing>] Error objectifying array or hash
    def objectify(result)
      if result.is_a?(Hash)
        ObjectifiedHash.new(result)
      elsif result.is_a? Array
        result.map! { |e| ObjectifiedHash.new(e) }
      elsif result.nil?
        nil
      else
        fail Error::Parsing, "Couldn't parse a response body"
      end
    end
  end
end
