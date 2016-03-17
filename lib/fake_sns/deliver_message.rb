require "forwardable"
require "faraday"
require_relative 'pool'

module FakeSNS
  class DeliverMessage

    extend Forwardable

    def self.call(options)
      new(options).call
    end

    attr_reader :subscription, :message, :config, :request

    def_delegators :subscription, :protocol, :endpoint, :arn

    def initialize(options)
      @subscription = options.fetch(:subscription)
      @message = options.fetch(:message)
      @request = options.fetch(:request)
      @config = options.fetch(:config)
    end

    def call
      method_name = protocol.gsub("-", "_")
      raise InvalidParameterValue, "Protocol #{protocol} not supported" unless valid_protocol(method_name)
      send(method_name)
    end

    def sqs
      queue_name = endpoint.split("/").last
      sqs = Aws::SQS::Client.new(
        region: region,
        credentials: Aws::Credentials.new(access_key_id, secret_access_key),
      ).tap { |client|
        client.config.endpoint = URI(sqs_endpoint)
      }
      queue_url = sqs.get_queue_url(queue_name: queue_name).queue_url
      sqs.send_message(queue_url: sqs_endpoint + '/' + queue_name, message_body: message_contents)
    end

    def region
      ENV['AWS_REGION'] || config.fetch('region')
    end

    def access_key_id
      ENV['AWS_ACCESS_KEY_ID'] || config.fetch('access_key_id')
    end

    def secret_access_key
      ENV['AWS_SECRET_ACCESS_KEY'] || config.fetch('secret_access_key')
    end

    def sqs_endpoint
      ENV['AWS_SQS_ENDPOINT'] || config.fetch('sqs_endpoint')
    end

    def http
      http_or_https
    end

    def https
      http_or_https
    end

    def email
      pending
    end

    def email_json
      pending
    end

    def sms
      pending
    end

    def application
      pending
    end

    def message_contents
      message.message_for_protocol protocol
    end

    private

    def valid_protocol(protocol)
      protocol =~ /(sqs)|(https?)/
    end

    def pending
      puts "Not sending to subscription #{arn}, because protocol #{protocol} has no fake implementation. Message: #{message.id} - #{message_contents.inspect}"
    end

    def http_or_https
      Pool.deliver(delivery: self)
    end

  end
end
