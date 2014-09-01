require 'httparty'
require 'libxml'

module Rundeck
  # @private
  class Request
    include HTTParty
    format :xml
    headers 'Accept' => 'application/xml'
    parser Proc.new { |body, _| parse(body) }

    attr_accessor :api_token

    def get(path, options = {})
      set_api_token_header(options)
      validate self.class.get(path, options)
    end

    def post(path, options = {})
      set_api_token_header(options, path)
      validate self.class.post(path, options)
    end

    def put(path, options = {})
      set_api_token_header(options)
      validate self.class.put(path, options)
    end

    def delete(path, options = {})
      set_api_token_header(options)
      validate self.class.delete(path, options)
    end

    # Checks the response code for common errors.
    # Returns parsed response for successful requests.
    def validate(response)
      case response.code
        when 400; raise Error::BadRequest.new error_message(response)
        when 401; raise Error::Unauthorized.new error_message(response)
        when 403; raise Error::Forbidden.new error_message(response)
        when 404; raise Error::NotFound.new error_message(response)
        when 405; raise Error::MethodNotAllowed.new error_message(response)
        when 409; raise Error::Conflict.new error_message(response)
        when 500; raise Error::InternalServerError.new error_message(response)
        when 502; raise Error::BadGateway.new error_message(response)
        when 503; raise Error::ServiceUnavailable.new error_message(response)
      end

      response.parsed_response
    end

    # Sets a base_uri and default_params for requests.
    # @raise [Error::MissingCredentials] if endpoint not set.
    def set_request_defaults(endpoint, api_token)
      raise Error::MissingCredentials.new("Please set an endpoint to API") unless endpoint
      @api_token = api_token

      self.class.base_uri endpoint
      # self.class.default_params :sudo => sudo
      # self.class.default_params.delete(:sudo) if sudo.nil?
    end

    private

    # Sets a PRIVATE-TOKEN header for requests.
    # @raise [Error::MissingCredentials] if api_token not set.
    def set_api_token_header(options, path=nil)
      unless path == '/j_security_check'
        raise Error::MissingCredentials.new("Please set a api_token for user") unless @api_token
        options[:headers] = {'X-Rundeck-Auth-Token' => @api_token}
      end
    end

    def error_message(response)
      "Server responded with code #{response.code}, message: #{response.parsed_response.message}. " \
      "Request URI: #{response.request.base_uri}#{response.request.path}"
    end
  end
end
