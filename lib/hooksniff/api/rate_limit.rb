# frozen_string_literal: true

module HookSniff
  class RateLimit
    def initialize(client)
      @client = client
    end

    def list
      @client.execute_request("GET", "/v1/rate-limits")
    end

    def get(endpoint_id)
      @client.execute_request("GET", "/v1/rate-limits/#{endpoint_id}")
    end

    def set(endpoint_id, attrs)
      @client.execute_request("POST", "/v1/rate-limits/#{endpoint_id}", body: attrs)
    end

    def delete(endpoint_id)
      @client.execute_request("DELETE", "/v1/rate-limits/#{endpoint_id}")
      nil
    end
  end
end
