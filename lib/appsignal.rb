raise 'This appsignal gem only works with rails' unless defined?(Rails)

module Appsignal
  class << self
    attr_accessor :subscriber

    # Convenience method for pushing a transaction straight to Appsignal,
    # skipping the queue.
    #
    # @return [ Boolean ] If successful or not
    #
    # @since 0.5.0
    def push(transaction)
    end

    # Convenience method for adding a transaction to the queue. This queue is
    # managed and is periodically pushed to Appsignal.
    #
    # @return [ true ] True.
    #
    # @since 0.5.0
    def enqueue(transaction)
      agent.enqueue(transaction)
    end

    def transactions
      @transactions ||= {}
    end

    def agent
      @agent ||= Appsignal::Agent.new
    end

    def logger
      @logger ||= Logger.new("#{Rails.root}/log/appsignal.log").tap do |l|
        l.level = Logger::INFO
      end
    end

    def config
      @config ||= Appsignal::Config.new(Rails.root, Rails.env).load
    end

    def post_processing_middleware
      @post_processing_chain ||= PostProcessor.default_middleware
      yield @post_processing_chain if block_given?
      @post_processing_chain
    end

    def active?
      config && config[:active] == true
    end

  end
end

require 'appsignal/agent'
require 'appsignal/aggregator'
require 'appsignal/auth_check'
require 'appsignal/cli'
require 'appsignal/config'
require 'appsignal/exception_notification'
require 'appsignal/listener'
require 'appsignal/marker'
require 'appsignal/middleware'
require 'appsignal/railtie'
require 'appsignal/transaction'
require 'appsignal/transmitter'
require 'appsignal/version'
