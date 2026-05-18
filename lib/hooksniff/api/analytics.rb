# frozen_string_literal: true

module HookSniff
  class Analytics
    def initialize(client)
      @client = client
    end

    def delivery_trend(params = {})
      @client.execute_request("GET", "/v1/analytics/deliveries", query_params: params)
    end

    def success_rate(params = {})
      @client.execute_request("GET", "/v1/analytics/success-rate", query_params: params)
    end

    def latency(params = {})
      @client.execute_request("GET", "/v1/analytics/latency", query_params: params)
    end
  end
end
