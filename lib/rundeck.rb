require 'rundeck/version'
require 'rundeck/configuration'
require 'rundeck/error'
require 'rundeck/objectified_hash'
require 'rundeck/request'
require 'rundeck/api'
require 'rundeck/client'

module Rundeck
  extend Configuration

  # Alias for Rundeck::Client.new
  #
  # @return [Rundeck::Client]
  def self.client(options = {})
    Rundeck::Client.new(options)
  end

  # Delegate to Gitlab::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Gitlab::Client
  def self.respond_to?(method)
    client.respond_to?(method) || super
  end
end
