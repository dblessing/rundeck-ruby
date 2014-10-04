module Helpers
  # Convenience methods to help test
  # shared context 'an options hash'

  def options
    { no_follow: true }
  end

  def method
    :get
  end

  # GET
  def stub_get(path, fixture, accept = 'xml')
    stub_request(:get, "#{Rundeck.endpoint}#{path}")
    .with(headers: { 'Accept' => "application/#{accept}",
                     'X-Rundeck-Auth-Token' => Rundeck.api_token })
    .to_return(body: load_fixture(fixture))
  end

  def a_get(path, accept = 'xml')
    a_request(:get, "#{Rundeck.endpoint}#{path}")
    .with(headers: { 'Accept' => "application/#{accept}",
                     'X-Rundeck-Auth-Token' => Rundeck.api_token })
  end

# POST
  def stub_post(path, fixture, status_code = 200, accept = 'xml')
    stub_request(:post, "#{Rundeck.endpoint}#{path}")
    .with(headers: { 'Accept' => "application/#{accept}",
                     'X-Rundeck-Auth-Token' => Rundeck.api_token })
    .to_return(body: load_fixture(fixture), status: status_code)
  end

  def a_post(path, accept = 'xml')
    a_request(:post, "#{Rundeck.endpoint}#{path}")
    .with(headers: { 'Accept' => "application/#{accept}",
                     'X-Rundeck-Auth-Token' => Rundeck.api_token })
  end

# PUT
  def stub_put(path, fixture, accept = 'xml')
    stub_request(:put, "#{Rundeck.endpoint}#{path}")
    .with(headers: { 'Accept' => "application/#{accept}",
                     'X-Rundeck-Auth-Token' => Rundeck.api_token })
    .to_return(body: load_fixture(fixture))
  end

  def a_put(path, accept = 'xml')
    a_request(:put, "#{Rundeck.endpoint}#{path}")
    .with(headers: { 'Accept' => "application/#{accept}",
                     'X-Rundeck-Auth-Token' => Rundeck.api_token })
  end

# DELETE
  def stub_delete(path, fixture, accept = 'xml')
    stub_request(:delete, "#{Rundeck.endpoint}#{path}")
    .with(headers: { 'Accept' => "application/#{accept}",
                     'X-Rundeck-Auth-Token' => Rundeck.api_token })
    .to_return(body: load_fixture(fixture))
  end

  def a_delete(path, accept = 'xml')
    a_request(:delete, "#{Rundeck.endpoint}#{path}")
    .with(headers: { 'Accept' => "application/#{accept}",
                     'X-Rundeck-Auth-Token' => Rundeck.api_token })
  end
end
