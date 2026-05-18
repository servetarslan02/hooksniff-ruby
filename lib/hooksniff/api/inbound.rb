# frozen_string_literal: true

module HookSniff
  class Inbound
    def initialize(client)
      @client = client
    end

    def list_configs
      @client.execute_request("GET", "/v1/inbound/configs")
    end

    def get_config(id)
      @client.execute_request("GET", "/v1/inbound/configs/#{id}")
    end

    def create_config(attrs)
      @client.execute_request("POST", "/v1/inbound/configs", body: attrs)
    end

    def update_config(id, attrs)
      @client.execute_request("PUT", "/v1/inbound/configs/#{id}", body: attrs)
    end

    def delete_config(id)
      @client.execute_request("DELETE", "/v1/inbound/configs/#{id}")
      nil
    end
  end
end
