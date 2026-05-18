# frozen_string_literal: true

module HookSniff
  class Connector
    def initialize(client)
      @client = client
    end

    def list(params = {})
      @client.execute_request("GET", "/v1/connectors", query_params: params)
    end

    def get(id)
      @client.execute_request("GET", "/v1/connectors/#{id}")
    end

    def list_configs
      @client.execute_request("GET", "/v1/connectors/configs")
    end

    def get_config(id)
      @client.execute_request("GET", "/v1/connectors/configs/#{id}")
    end

    def create_config(attrs)
      @client.execute_request("POST", "/v1/connectors/configs", body: attrs)
    end

    def update_config(id, attrs)
      @client.execute_request("PUT", "/v1/connectors/configs/#{id}", body: attrs)
    end
  end
end
