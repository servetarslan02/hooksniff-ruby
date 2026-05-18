# frozen_string_literal: true

module HookSniff
  class OperationalWebhook
    def initialize(client)
      @client = client
    end

    def list_endpoints(params = {})
      @client.execute_request("GET", "/v1/operational-webhooks", query_params: params)
    end

    def get_endpoint(id)
      @client.execute_request("GET", "/v1/operational-webhooks/#{id}")
    end

    def create_endpoint(attrs)
      @client.execute_request("POST", "/v1/operational-webhooks", body: attrs)
    end

    def update_endpoint(id, attrs)
      @client.execute_request("PUT", "/v1/operational-webhooks/#{id}", body: attrs)
    end

    def delete_endpoint(id)
      @client.execute_request("DELETE", "/v1/operational-webhooks/#{id}")
      nil
    end

    def list_deliveries(endpoint_id)
      @client.execute_request("GET", "/v1/operational-webhooks/#{endpoint_id}/deliveries")
    end
  end
end
