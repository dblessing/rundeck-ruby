# Development

Helpful instructions for developers of the Rundeck Ruby gem.

## Testing

Rundeck gem is tested using RSpec. VCR cassettes record API calls
and replay the results back when tests are run. VCR
helps avoid bugs because the developer is not responsible for
flawlessly recreating the expected Rundeck API response. When a new
Rundeck version is released developers can easily move/remove the existing
cassettes and run tests against a Rundeck instance running in a Vagrant
box. VCR will record the new responses and hopefully there are no errors.
Errors may occur if Rundeck developers have introduced a bug or created
breaking API changes. This gem aims to create all its own required objects
when a new cassette recording is required.

### Integration/Acceptance testing

1. Archive all old cassettes (suggested move `spec/cassettes/#{version}` to
`spec/cassettes/old/#{version}`.
1. Bring up the Vagrant box. `vagrant up --provider=virtualbox`
1. Visit (http://192.168.50.2:4440/) in your browser.
1. Login with username and password `admin`.
1. Obtain/generate an admin user API token. Admin -> Profile, specify an
email address, then click 'Generate New Token'.
1. Export the token as an environment variable.
`export TEST_RUNDECK_API_TOKEN=vDCT9dP6evCJYHtWoivruQtymkLTGJXq`
1. Run RSpec. `bundle exec rake`

### Unit testing

Or, running tests from existing cassettes.

# TODO:
