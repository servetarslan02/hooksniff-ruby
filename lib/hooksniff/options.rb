# frozen_string_literal: true

module HookSniff
  # Configuration options for the HookSniff client.
  #
  # @example
  #   options = HookSniff::Options.new(
  #     server_url: "https://custom.hooksniff.com",
  #     timeout: 60,
  #     debug: true,
  #     headers: { "X-Custom" => "value" }
  #   )
  #   client = HookSniff::HookSniff.new("token", options)
  class Options
    attr_accessor :server_url, :timeout, :debug, :headers, :retry_schedule

    def initialize(
      server_url: nil,
      timeout: 30,
      debug: false,
      headers: {},
      retry_schedule: [1, 2, 4]
    )
      @server_url = server_url
      @timeout = timeout
      @debug = debug
      @headers = headers || {}
      @retry_schedule = retry_schedule
    end
  end
end
