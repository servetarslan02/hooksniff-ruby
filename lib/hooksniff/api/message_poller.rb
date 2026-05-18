# frozen_string_literal: true

module HookSniff
  class MessagePoller
    def initialize(client)
      @client = client
    end

    def poll(params = {})
      @client.execute_request("GET", "/v1/message-poller/poll", query_params: params)
    end

    def seek(attrs)
      @client.execute_request("POST", "/v1/message-poller/seek", body: attrs)
    end

    def commit(attrs)
      @client.execute_request("POST", "/v1/message-poller/commit", body: attrs)
    end
  end
end
