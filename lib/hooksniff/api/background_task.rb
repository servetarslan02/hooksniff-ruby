# frozen_string_literal: true

module HookSniff
  class BackgroundTask
    def initialize(client)
      @client = client
    end

    def list(params = {})
      @client.execute_request("GET", "/v1/background-tasks", query_params: params)
    end

    def get(id)
      @client.execute_request("GET", "/v1/background-tasks/#{id}")
    end

    def cancel(id)
      @client.execute_request("PUT", "/v1/background-tasks/#{id}")
    end
  end
end
