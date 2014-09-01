module Rundeck
  # Wrapper for the Rundeck REST API.
  class Client < API
    Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

    include Jobs

    def objectify(result)
      if result.is_a? Hash
        ObjectifiedHash.new body
      elsif result.is_a? Array
        result.map! { |e| ObjectifiedHash.new(e) }
      else
        fail Error::Parsing, "Couldn't parse a response body"
      end
    end
  end
end
