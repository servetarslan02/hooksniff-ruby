# frozen_string_literal: true

module HookSniff
  class Routing
    def initialize(client)
      @client = client
    end

    def get(endpoint_id)
      @client.execute_request("GET", "/v1/routing/#{endpoint_id}/routing")
    end

    def update(endpoint_id, attrs)
      @client.execute_request("PUT", "/v1/routing/#{endpoint_id}/routing", body: attrs)
    end

    def get_health(endpoint_id)
      @client.execute_request("GET", "/v1/routing/#{endpoint_id}/health")
    end
  end
end
